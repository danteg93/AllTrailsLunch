//
//  PlacesRepo.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation

class PlacesRepo {

    
    private let placesDataSource = GooglePlacesDataSource.shared
    private let locationDataSource = LocationDataSource.shared
    
    var latestSearchPublisher = EntityPublisher.Cached<NearbyRestaurantsEntity>(.success(NearbyRestaurantsEntity(results: [])))
    
    private var latestSearchCache: [String: PlaceEntity] = [:]
    private var userSelectedPlaceId: String? = nil
    
    private init() {}
    static let shared = PlacesRepo()
    
    func getNearbyRestaurants(arguments: NearbyRestaurantsEntity.Arguments,
                              handler: @escaping NearbyRestaurantsEntity.ResultHandler) {
        
        guard let currentCoordinate = self.locationDataSource.currentCoordinate else {
            handler(.failure(.dataSourceError))
            return
        }
        
        self.placesDataSource.findNearbyRestaurants(latitude: currentCoordinate.latitude,
                                                    longitude: currentCoordinate.longitude,
                                                    keyword: arguments.keyword) { [weak self, handler] (data, error) in
            guard error == nil else {
                handler(.failure(.dataSourceError))
                return
            }
            if let data = data, let entity = NearbyRestaurantsEntity.fromData(data) {
                // Store in temp cache for quick access
                self?.latestSearchCache = entity.results.reduce([String: PlaceEntity]()) { (dictionary, entity) -> [String: PlaceEntity] in
                    var dictionary = dictionary
                    if let placeId = entity.placeId {
                        dictionary[placeId] = entity
                    }
                    return dictionary
                }
                // Update Observers
                self?.latestSearchPublisher.send(.success(entity))
                handler(.success(entity))
            } else {
                handler(.failure(.dataSourceError))
            }
        }
    }
    
    func setSelectedPlace(arguments: SelectPlaceEntity.Arguments) {
        self.userSelectedPlaceId = arguments.placeId
    }
    
    func getSelectedPlace() -> PlaceEntity? {
        guard let userSelectedPlaceId = userSelectedPlaceId else {
            return nil
        }
        return latestSearchCache[userSelectedPlaceId]
    }
    
}

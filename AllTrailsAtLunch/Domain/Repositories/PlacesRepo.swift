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
    
    //private var latestSearchCache: [PlaceEntity] = []
    
    //var locationPermissionsPublisher = EntityPublisher.Passthrough<NearbyRestaurantsEntity>()
    
    var latestSearchCache = EntityPublisher.Cached<NearbyRestaurantsEntity>(.success(NearbyRestaurantsEntity(results: [])))
    
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
                self?.latestSearchCache.send(.success(entity))
                handler(.success(entity))
            } else {
                handler(.failure(.dataSourceError))
            }
        }
    }
    
}

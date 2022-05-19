//
//  NearbyRestaurantsEntity.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation
import Combine

struct NearbyRestaurantsArguments {
    let keyword: String?
}

struct NearbyRestaurantsEntity: AsyncEntity, ObservableEntity, DataDecodableEntity {

    typealias DomainError = PlacesError
    typealias Arguments = NearbyRestaurantsArguments
    
    let results: [PlaceEntity]
    
    static func asyncRequest(arguments: NearbyRestaurantsArguments?, handler: @escaping ResultHandler) {
        guard let arguments = arguments else {
            handler(.failure(.dataSourceError))
            return
        }
        PlacesRepo.shared.getNearbyRestaurants(arguments: arguments, handler: handler)
    }
    
    static func subscribe(arguments: NearbyRestaurantsArguments? = nil, updateHandler: @escaping ResultHandler) -> AnyCancellable? {
        PlacesRepo.shared.latestSearchPublisher.sink(receiveCompletion: { _ in }, receiveValue: { result in
            updateHandler(result)
        })
    }
    
}

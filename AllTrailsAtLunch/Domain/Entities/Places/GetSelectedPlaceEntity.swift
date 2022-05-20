//
//  GetSelectedPlaceEntity.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation

struct GetSelectedPlaceEntity: SyncEntity {
    
    typealias Arguments = NoArguments
    
    let place: PlaceEntity
    
    static func syncRequest(arguments: NoArguments? = .none) -> GetSelectedPlaceEntity? {
        guard let selectedPlace = PlacesRepo.shared.getSelectedPlace() else {
            return nil
        }
        return GetSelectedPlaceEntity(place: selectedPlace)
    }
}

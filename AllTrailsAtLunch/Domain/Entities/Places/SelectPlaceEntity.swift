//
//  SelectPlaceEntity.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation

struct SelectPlaceArguments {
    let placeId: String
}
struct SelectPlaceEntity: SyncEntity {
    
    typealias Arguments = SelectPlaceArguments
    
    static func syncRequest(arguments: SelectPlaceArguments?) -> SelectPlaceEntity? {
        guard let arguments = arguments else {
            return nil
        }
        PlacesRepo.shared.setSelectedPlace(arguments: arguments)
        return SelectPlaceEntity()
    }
}

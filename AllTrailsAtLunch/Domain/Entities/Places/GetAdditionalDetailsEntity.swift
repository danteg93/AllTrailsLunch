//
//  GetAdditionalDetailsEntity.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation


struct GetAdditionalDetailsArguments {
    let placeId: String
}

struct GetAdditionalDetailsEntity: AsyncEntity, DataDecodableEntity {
    typealias DomainError = PlacesError
    typealias Arguments = GetAdditionalDetailsArguments
    
    let result: AdditionalDetailsEntity
    
    static func asyncRequest(arguments: GetAdditionalDetailsArguments?, handler: @escaping ResultHandler) {
        guard let arguments = arguments else {
            handler(.failure(.dataSourceError))
            return
        }
        PlacesRepo.shared.getAdditionalDetails(arguments: arguments, handler: handler)
    }
}

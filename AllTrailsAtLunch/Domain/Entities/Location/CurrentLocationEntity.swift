//
//  CurrentLocationEntity.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation

struct CurrentLocationEntity: SyncEntity {
    
    typealias Arguments = NoArguments
    
    let latitude: Double
    let longitude: Double
    
    static func syncRequest(arguments: NoArguments? = .none) -> CurrentLocationEntity? {
        LocationManager.shared.getCurrentLocation()
    }
    
}

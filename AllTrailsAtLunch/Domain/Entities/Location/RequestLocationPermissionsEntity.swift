//
//  RequestLocationPermissionsEntity.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation

struct RequestLocationPermissionsEntity: SyncEntity {
    typealias Arguments = NoArguments
    
    static func syncRequest(arguments: NoArguments? = .none) -> RequestLocationPermissionsEntity? {
        LocationManager.shared.requestPermissions()
        return RequestLocationPermissionsEntity()
    }
    
}

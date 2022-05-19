//
//  LocationPermissionsEntity.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation
import Combine


struct LocationPermissionsEntity: ObservableEntity {
    
    typealias DomainError = LocationError
    typealias Arguments = NoArguments
    
    enum PermissionsStatus {
        case notDetermined
        case denied
        case authorized
    }
    
    private(set) public var permissionsStatus: PermissionsStatus = .notDetermined
    
    static func subscribe(arguments: NoArguments?, updateHandler: @escaping ResultHandler) -> AnyCancellable? {
        LocationManager.shared.observeLocationPermissions()
        return LocationManager.shared.locationPermissionsPublisher
            .sink(receiveCompletion: { _ in }, receiveValue: { result in
                updateHandler(result)
            })
    }
    
}

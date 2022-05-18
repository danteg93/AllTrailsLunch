//
//  LocationManager.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/17/22.
//

import Foundation

class LocationManager {
    
    private init() {}
    static let shared = LocationManager()
    private let locationDataSource = LocationDataSource.shared
    
    var locationPermissionsPublisher = EntityPublisher.Passthrough<LocationPermissionsEntity>()
        
    func observeLocationPermissions() {
        self.locationDataSource.observeLocationPermissionStatus { [weak self] permissionsStatus in
            switch permissionsStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                let permissionsEntity = LocationPermissionsEntity(permissionsStatus: .authorized)
                self?.locationPermissionsPublisher.send(.success(permissionsEntity))
            case .notDetermined:
                let permissionsEntity = LocationPermissionsEntity(permissionsStatus: .notDetermined)
                self?.locationPermissionsPublisher.send(.success(permissionsEntity))
            case .denied, .restricted:
                let permissionsEntity = LocationPermissionsEntity(permissionsStatus: .denied)
                self?.locationPermissionsPublisher.send(.success(permissionsEntity))
            @unknown default:
                let permissionsEntity = LocationPermissionsEntity(permissionsStatus: .denied)
                self?.locationPermissionsPublisher.send(.success(permissionsEntity))
            }
        }
    }
    
}
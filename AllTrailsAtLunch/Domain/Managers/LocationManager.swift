//
//  LocationManager.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/17/22.
//

import Foundation

class LocationManager {
    
    private let locationDataSource = LocationDataSource.shared
    
    var locationPermissionsPublisher = EntityPublisher.Passthrough<LocationPermissionsEntity>()
    
    private init() {}
    static let shared = LocationManager()
    
    
    func requestPermissions() {
        self.locationDataSource.requestLocationPermissions()
    }
        
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
    
    func getCurrentLocation() -> CurrentLocationEntity? {
        guard let currentCoordinate = self.locationDataSource.currentCoordinate else {
            return nil
        }
        return CurrentLocationEntity(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
    }
    
}

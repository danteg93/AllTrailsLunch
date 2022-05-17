//
//  LocationManager.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/17/22.
//

import CoreLocation

class LocationManager: NSObject {
    
    typealias LocationPermissionsStateHandler = (CLAuthorizationStatus) -> Void
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    private var locationPermissionsObserver: LocationPermissionsStateHandler? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    var authorizationStatus:  CLAuthorizationStatus {
        return self.locationManager.authorizationStatus
    }
    
    func observeLocationPermissionStatus(handler: @escaping LocationPermissionsStateHandler) {
        self.locationPermissionsObserver = handler
        self.locationPermissionsObserver?(self.authorizationStatus)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager == self.locationManager else { return }
        self.locationPermissionsObserver?(manager.authorizationStatus)
    }
    
}

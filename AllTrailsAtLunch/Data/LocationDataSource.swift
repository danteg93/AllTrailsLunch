//
//  LocationDataSource.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/17/22.
//

import CoreLocation

class LocationDataSource: NSObject {
    
    typealias LocationPermissionsStateHandler = (CLAuthorizationStatus) -> Void
    
    static let shared = LocationDataSource()
    
    private let locationManager = CLLocationManager()
    
    private var locationPermissionsObserver: LocationPermissionsStateHandler? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    private var authorizationStatus:  CLAuthorizationStatus {
        return self.locationManager.authorizationStatus
    }
    
    var currentCoordinate: CLLocationCoordinate2D? {
        self.locationManager.location?.coordinate
    }
    
    func observeLocationPermissionStatus(handler: @escaping LocationPermissionsStateHandler) {
        self.locationPermissionsObserver = handler
        self.locationPermissionsObserver?(self.authorizationStatus)
    }
    
    func requestLocationPermissions() {
        self.locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationDataSource: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager == self.locationManager else { return }
        self.locationPermissionsObserver?(manager.authorizationStatus)
    }
    
}


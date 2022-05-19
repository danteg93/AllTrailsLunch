//
//  MapViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation
import GoogleMaps
import Combine

class MapViewController: LayoutReadyViewController {
    
    var placesSub: AnyCancellable?
    
    override func viewDidLoad() {
        if let currentLocation = CurrentLocationEntity.syncRequest() {
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude,
                                                  longitude: currentLocation.longitude,
                                                  zoom: 13.0)
            let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            self.view.addSubview(mapView)
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
            let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            mapView.isMyLocationEnabled = true
            self.view.addSubview(mapView)
        }
    }
    
    override func viewIsReady() {
        self.placesSub = NearbyRestaurantsEntity.subscribe { [weak self] (result) in
            switch result {
            case .success(let entity):
                print("In the map got places \(entity.results.first)")
            case .failure:
                print("lol")
            }
        }
    }
    
    private func findNearbyPlaces() {
        
    }
    
    deinit {
        self.placesSub?.cancel()
    }
    
}

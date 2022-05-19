//
//  MapViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation
import GoogleMaps

class MapViewController: LayoutReadyViewController {
    
    override func viewDidLoad() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
    }
    
}

//
//  MapViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation
import GoogleMaps
import Combine

class MapViewController: LayoutReadyViewController, Displayable {
    
    typealias State = MapViewState
    typealias Presenter = MapViewPresenter
    
    var placesSub: AnyCancellable?
    
    var presenter: MapViewPresenter?
    
    private var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPresenter()
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
        super.viewIsReady()
        self.presenter?.setup()
    }
    
    func display(_ displayableState: DisplayableState) {
        switch displayableState {
        case .stateNotRequested:
            break
        case .empty:
            break
        case .loading:
            break
        case .error:
            break
        case .populated:
            self.updateMap()
        }
    }
    
    private func updateMap() {
        guard let mapView = self.mapView else {
            self.createMap()
            return
        }
        DispatchQueue.main.async {
            guard let places = self.presenter?.viewModel.places else { return }
            mapView.clear()
            for place in places {
                guard let location = place.geometry?.location else { continue }
                let postition = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
                let marker = GMSMarker(position: postition)
                marker.title = place.name
                marker.map = mapView
            }
            
        }
        
    }
    
    private func createMap() {
        guard let currentLocation = self.presenter?.viewModel.currentLocation else { return }
        DispatchQueue.main.async {
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude,
                                                  longitude: currentLocation.longitude,
                                                  zoom: 13.0)
            let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            self.mapView = mapView
            self.view.addSubview(mapView)
            self.updateMap()
        }
    }
    
    deinit {
        self.placesSub?.cancel()
    }
    
}

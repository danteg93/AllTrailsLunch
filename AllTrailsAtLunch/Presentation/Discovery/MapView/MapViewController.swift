//
//  MapViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation
import GoogleMaps
import Combine

protocol MapViewControllerDelegate: AnyObject {
    func placeTapped(placeIdSelected: String)
}

class MapViewController: LayoutReadyViewController, Displayable {
    
    typealias State = MapViewState
    typealias Presenter = MapViewPresenter
    
    var placesSub: AnyCancellable?
    
    var presenter: MapViewPresenter?
    
    weak var delegate: MapViewControllerDelegate?
    
    private var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPresenter()
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
                marker.icon = GMSMarker.markerImage(with: UIColor(named: "ActionBackground"))
                marker.title = place.name
                marker.map = mapView
                marker.userData = place.placeId ?? ""
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
            self.mapView?.delegate = self
            self.view.addSubview(mapView)
            self.updateMap()
        }
    }
    
    deinit {
        self.placesSub?.cancel()
    }
}

extension MapViewController: GMSMapViewDelegate {
        
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let placeId = marker.userData as? String else {
            return
        }
        self.delegate?.placeTapped(placeIdSelected: placeId)
    }
    
}

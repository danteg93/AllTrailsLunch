//
//  PlaceDetailViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation
import UIKit
import GoogleMaps

class PlaceDetailViewController: LayoutReadyViewController, Displayable {
    typealias State = PlaceDetailViewState
    typealias Presenter = PlaceDetailPresenter
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mapViewContainer: UIView!
    
    var presenter: PlaceDetailPresenter?
    
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
            self.populateView()
        }
    }
    
    private func populateView() {
        DispatchQueue.main.async {
            guard let place = self.presenter?.viewModel.selectedPlace else { return }
            self.updateMap()
            self.titleLabel.text = place.name
        }
    }
    
    private func updateMap() {
        guard let mapView = self.mapView else {
            self.createMap()
            return
        }
        DispatchQueue.main.async {
            guard let place = self.presenter?.viewModel.selectedPlace, let location = place.geometry?.location else { return }
            mapView.clear()
            let postition = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
            let marker = GMSMarker(position: postition)
            marker.icon = GMSMarker.markerImage(with: UIColor(named: "ActionBackground"))
            marker.map = mapView
        }
    }
    
    private func createMap() {
        guard let location = self.presenter?.viewModel.selectedPlace?.geometry?.location else { return }
        DispatchQueue.main.async {
            let camera = GMSCameraPosition.camera(withLatitude: location.lat,
                                                  longitude: location.lng,
                                                  zoom: 16.0)
            let mapView = GMSMapView.map(withFrame: self.mapViewContainer.bounds, camera: camera)
            mapView.settings.scrollGestures = false
            self.mapView = mapView
            self.mapViewContainer.addSubview(mapView)
            self.updateMap()
        }
    }
}

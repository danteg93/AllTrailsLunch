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
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var websiteLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var ratingCountLabel: UILabel!
    
    @IBOutlet var starImageCollection: [UIImageView]!
    
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
            #if targetEnvironment(simulator)
                // Skipping map because there is a known crash casued by GoogleMaps running on iOS15 simulators
                // https://issuetracker.google.com/issues/208490523?pli=1
            #else
                self.updateMap()
            #endif
            self.titleLabel.text = place.name
            // Using rating count label to display price point
            var ratingCountText = "(\(place.userRatingsTotal ?? 0))"
            if let priceLevel = place.priceLevel {
                ratingCountText.append(" • ")
                if priceLevel == 0 {
                    ratingCountText.append("Free")
                } else {
                    for _ in 0 ..< priceLevel {
                        ratingCountText.append("$")
                    }
                }
            }
            self.ratingCountLabel.text = ratingCountText
            // Set Rating
            for imageIndex in 0..<5 {
                self.starImageCollection[imageIndex].tintColor = Double(imageIndex) < (place.rating ?? 0).rounded() ? .orange : .lightGray
            }
            // Populate Additional Details
            if let additionalDetails = self.presenter?.viewModel.aditionalDetails {
                var openingHoursText = ""
                if let weekText = additionalDetails.openingHours?.weekday_text {
                    for (index, text) in weekText.enumerated() {
                        openingHoursText.append(text)
                        if index != weekText.count - 1 {
                            openingHoursText.append("\n")
                        }
                    }
                }
                self.addressLabel.text = additionalDetails.address
                self.websiteLabel.text = additionalDetails.website
                self.phoneLabel.text = additionalDetails.phoneNumber
                self.hoursLabel.text = openingHoursText
            }
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

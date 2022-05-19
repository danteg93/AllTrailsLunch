//
//  MapViewPresenter.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Combine
import Foundation

struct MapViewState {
    var places: [PlaceEntity] = []
    var currentLocation: CurrentLocationEntity? = nil
}

class MapViewPresenter: Presentable {
    
    var viewModel = MapViewState()
    var error: Error?
    var display: DisplayLogic
    
    private var placesCacheObserver: AnyCancellable?
    
    required init (display: @escaping DisplayLogic) {
        self.display = display
    }
    
    func setup() {
        guard let currentLocation = CurrentLocationEntity.syncRequest() else { return }
        self.viewModel.currentLocation = currentLocation
        self.placesCacheObserver = NearbyRestaurantsEntity.subscribe { [weak self] (result) in
            switch result {
            case .success(let entity):
                self?.viewModel.places = entity.results
                self?.display(.populated)
            case .failure:
                break
            }
        }
    }
    
    deinit {
        self.placesCacheObserver?.cancel()
    }
}

//
//  ListViewPresenter.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation
import Combine

struct ListViewState {
    
    var places: [PlaceEntity] = []
}

class ListViewPresenter: Presentable {
    
    var viewModel = ListViewState()
    var error: Error?
    var display: DisplayLogic
    
    private var placesCacheObserver: AnyCancellable?
    
    required init(display: @escaping DisplayLogic) {
        self.display = display
    }
    
    func setup() {
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

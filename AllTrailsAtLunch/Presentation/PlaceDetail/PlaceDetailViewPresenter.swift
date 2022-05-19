//
//  PlaceDetailViewPresenter.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation

struct PlaceDetailViewState {
    var selectedPlace: PlaceEntity? = nil
}

class PlaceDetailPresenter: Presentable {
    var viewModel = PlaceDetailViewState()
    var error: Error?
    var display: DisplayLogic
    
    required init(display: @escaping DisplayLogic) {
        self.display = display
    }
    
    func setup() {
        self.viewModel.selectedPlace = GetSelectedPlaceEntity.syncRequest()?.place
        self.display(.populated)
    }
}

//
//  PlaceDetailViewPresenter.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation

struct PlaceDetailViewState {
    var selectedPlace: PlaceEntity? = nil
    var aditionalDetails: AdditionalDetailsEntity? = nil
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
        if let selectedPlaceId = self.viewModel.selectedPlace?.placeId {
            let arguments = GetAdditionalDetailsArguments(placeId: selectedPlaceId)
            GetAdditionalDetailsEntity.asyncRequest(arguments: arguments) { [weak self] (result) in
                switch result {
                case .failure:
                    return
                case .success(let entity):
                    self?.viewModel.aditionalDetails = entity.result
                    self?.display(.populated)
                }
            }
        }
    }
}

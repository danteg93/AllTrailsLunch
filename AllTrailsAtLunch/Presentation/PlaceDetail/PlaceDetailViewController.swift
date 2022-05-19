//
//  PlaceDetailViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation
import UIKit

class PlaceDetailViewController: LayoutReadyViewController, Displayable {
    typealias State = PlaceDetailViewState
    typealias Presenter = PlaceDetailPresenter
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    var presenter: PlaceDetailPresenter?
    
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
            self.titleLabel.text = place.name
        }
    }
}

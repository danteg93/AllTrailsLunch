//
//  ContainerSwitchViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/15/22.
//

import UIKit

class ContainerSwitchViewController: LayoutReadyViewController, Displayable {
    
    typealias State = ContainerSwitchState
    typealias Presenter = ContainerSwitchPresenter
    
    private var activeViewController: UIViewController?
    
    var presenter: ContainerSwitchPresenter?
    
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
        case .stateNotRequested: break
        case .empty: break
        case .loading: break
        case .error: break
        case .populated:
            self.populateView()
        }
    }
    
    private func populateView() {
        guard let _ = self.presenter?.viewModel else { return }
        DispatchQueue.main.async {
            self.view.backgroundColor = .systemOrange
        }
    }
    
}

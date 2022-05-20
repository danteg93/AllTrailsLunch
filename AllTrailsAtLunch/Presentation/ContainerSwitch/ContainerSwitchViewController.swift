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
    
    @IBOutlet private weak var troubleshootContainer: UIView!
    @IBOutlet private weak var discoveryContainer: UIView!
    
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
        guard let viewModel = self.presenter?.viewModel else { return }
        switch viewModel.sceneToPresent {
        case .notDetermined:
            self.displayPermissionsRequest()
        case .discovery:
            self.displayDiscovery()
        case .troubleshoot:
            self.displayTroubleshoot()
        }
    }
    
    private func displayDiscovery() {
        self.removeViewController(self.activeViewController, from: self.troubleshootContainer)
        self.activeViewController = nil
        let discoveryViewController = DiscoveryViewController()
        self.addViewController(discoveryViewController, to: self.discoveryContainer)
        self.activeViewController = discoveryViewController
    }
    
    private func displayTroubleshoot() {
        self.removeViewController(self.activeViewController, from: self.discoveryContainer)
        self.activeViewController = nil
        let troubleshootViewController = TroubleshootViewController()
        self.addViewController(troubleshootViewController, to: self.troubleshootContainer)
        self.activeViewController = troubleshootViewController
    }
    
    private func displayPermissionsRequest() {
        if let activeViewController = self.activeViewController {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.troubleshootContainer.alpha = 0
                    self.discoveryContainer.alpha = 0
                }, completion: { (completed) in
                    activeViewController.willMove(toParent: nil)
                    activeViewController.view.removeFromSuperview()
                    activeViewController.removeFromParent()
                })
            }
        }
        self.presenter?.requestLocationPermissions()
    }
}

extension ContainerSwitchViewController {
    
    private func removeViewController(_ viewController: UIViewController?, from container: UIView) {
        guard let viewController = viewController else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                container.alpha = 0
            }, completion: { (completed) in
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            })
        }
    }
    
    private func addViewController(_ viewController: UIViewController?, to container: UIView) {
        guard let viewController = viewController else { return }
        
        DispatchQueue.main.async {
            viewController.willMove(toParent: self)
            self.addChild(viewController)
            viewController.view.frame = container.frame
            container.addSubview(viewController.view)
            viewController.didMove(toParent: self)
            UIView.animate(withDuration: 0.3, animations: {
                container.alpha = 1
            }, completion: nil)
        }
        
    }
}

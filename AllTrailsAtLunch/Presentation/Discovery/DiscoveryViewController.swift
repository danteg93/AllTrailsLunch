//
//  DiscoveryViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import UIKit

class DiscoveryViewController: LayoutReadyViewController, Displayable {
    
    typealias State = DiscoveryState
    typealias Presenter = DiscoveryViewPresenter
    
    private enum Constants {
        static let listButtonTitle = "List".localized
        static let mapButtonTitle = "Map".localized
        static let listImage = UIImage(systemName: "list.bullet")
        static let mapImage = UIImage(systemName: "map.circle")
    }
    
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var modeSwitchButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var mapViewController: MapViewController?
    private var listViewController: ListViewController?
    
    var presenter: DiscoveryViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPresenter()
        self.modeSwitchButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.modeSwitchButton.alignTextAndImage(spacing: 10)
        self.searchBar.searchTextField.leftView?.tintColor = UIColor(named: "ActionBackground")
        
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        self.searchBar.delegate = self
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
            self.displaySelectedMode()
        }
    }
    
    private func displaySelectedMode() {
        guard let desiredMode = self.presenter?.viewModel.desiredMode,
              desiredMode != self.presenter?.viewModel.activeMode else {
            return
        }
        // Update Button
        self.updateModeSwitchButton()
        // Updated View Controller
        var selectedViewController: UIViewController?
        switch desiredMode {
        case .map:
            if self.mapViewController == nil {
                self.mapViewController = MapViewController()
                self.mapViewController?.delegate = self
            }
            selectedViewController = self.mapViewController
        case .list:
            if self.listViewController == nil {
                self.listViewController = ListViewController()
                self.listViewController?.delegate = self
            }
            selectedViewController = self.listViewController
        case .detail:
            self.showPlaceDetail()
        }
        
        if let selectedViewController = selectedViewController {
            self.displayViewController(selectedViewController)
        }
    }
    
    private func updateModeSwitchButton() {
        guard let desiredMode = self.presenter?.viewModel.desiredMode else { return }
        DispatchQueue.main.async {
            switch desiredMode {
            case .list:
                self.modeSwitchButton.setImage(Constants.mapImage, for: .normal)
                self.modeSwitchButton.setTitle(Constants.mapButtonTitle, for: .normal)
            case .map:
                self.modeSwitchButton.setImage(Constants.listImage, for: .normal)
                self.modeSwitchButton.setTitle(Constants.listButtonTitle, for: .normal)
            case .detail:
                return
            }
            self.modeSwitchButton.alpha = 1.0
        }
    }
    
    @IBAction func tappedModeSwitch() {
        guard let activeMode = self.presenter?.viewModel.activeMode else { return }
        switch activeMode {
        case .map:
            self.presenter?.updateDesiredMode(.list)
        case .list:
            self.presenter?.updateDesiredMode(.map)
        case .detail:
            return
        }
    }
    
}

extension DiscoveryViewController {
    
    private func displayViewController(_ viewController: UIViewController) {
        self.removeActiveViewController()
        DispatchQueue.main.async {
            viewController.willMove(toParent: self)
            self.addChild(viewController)
            viewController.didMove(toParent: self)
            viewController.view.frame = self.viewContainer.bounds
            self.viewContainer.addSubview(viewController.view)
            self.presenter?.activeModeUpdatedToDesired()
        }
    }
    
    private func removeActiveViewController() {
        guard let activeMode = self.presenter?.viewModel.activeMode else { return }
        var activeViewController: UIViewController?
        switch activeMode {
        case .map:
            activeViewController = self.mapViewController
        case .list:
            activeViewController = self.listViewController
        case .detail:
            return
        }
        if let activeViewController = activeViewController {
            DispatchQueue.main.async {
                activeViewController.willMove(toParent: nil)
                activeViewController.view.removeFromSuperview()
                activeViewController.removeFromParent()
            }
        }
    }
    
    private func showPlaceDetail() {
        DispatchQueue.main.async {
            let navController = UINavigationController(rootViewController: PlaceDetailViewController())
            navController.setNavigationBarHidden(true, animated: false)
            navController.modalPresentationStyle = .pageSheet
            self.present(navController, animated: true, completion: nil)
        }
    }
    
}

extension DiscoveryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let searchText = searchBar.text {
            self.presenter?.searchNearbyPlaces(searchText)
        }
    }
    
}

extension DiscoveryViewController: ListViewControllerDelegate, MapViewControllerDelegate {
    func placeTapped(placeIdSelected: String) {
        self.presenter?.setSelectedPlace(placeId: placeIdSelected)
    }
}

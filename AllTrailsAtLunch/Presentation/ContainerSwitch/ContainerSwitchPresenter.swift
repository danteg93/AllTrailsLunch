//
//  ContainerSwitchPresenter.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/16/22.
//

import Foundation
import Combine

struct ContainerSwitchState {
    
    enum SceneToPresent {
        case troubleshoot
        case discovery
        case notDetermined
    }
    
    var sceneToPresent = SceneToPresent.notDetermined
}

class ContainerSwitchPresenter: Presentable {
    
    var viewModel = ContainerSwitchState()
    var error: Error?
    var display: DisplayLogic
    
    var permissionsSubscription: AnyCancellable?
    
    required init(display: @escaping DisplayLogic) {
        self.display = display
    }
    
    func setup() { 
        self.permissionsSubscription = LocationPermissionsEntity.subscribe(arguments: .none) { [weak self] result in
            switch result {
            case .success(let entity):
                switch entity.permissionsStatus {
                case .notDetermined:
                    self?.viewModel.sceneToPresent = .notDetermined
                case .denied:
                    self?.viewModel.sceneToPresent = .troubleshoot
                case .authorized:
                    self?.viewModel.sceneToPresent = .discovery
                }
                self?.display(.populated)
            case .failure:
                print("error")
            }
        }
    }
    
    func requestLocationPermissions() {
        _ = RequestLocationPermissionsEntity.syncRequest()
    }
}

//
//  ContainerSwitchPresenter.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/16/22.
//

import Foundation
import Combine

struct ContainerSwitchState {
  var shouldReroute = false
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
        //print("What \(LocationDataSource.shared.authorizationStatus == .notDetermined)")
        print("Hello there")
        self.permissionsSubscription = LocationPermissionsEntity.subscribe(arguments: .none) { result in
            switch result {
            case .success(let entity):
                print("We got \(entity.permissionsStatus)")
            case .failure:
                print("error")
            }
        }
        self.display(.populated)
    }
    
}

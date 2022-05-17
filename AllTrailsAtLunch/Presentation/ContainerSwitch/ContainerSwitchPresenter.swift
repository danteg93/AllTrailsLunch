//
//  ContainerSwitchPresenter.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/16/22.
//

import Foundation


struct ContainerSwitchState {
  var shouldReroute = false
}

class ContainerSwitchPresenter: Presentable {
    
    var viewModel = ContainerSwitchState()
    var error: Error?
    var display: DisplayLogic
    
    required init(display: @escaping DisplayLogic) {
        self.display = display
    }
    
    func setup() {
        print("What \(LocationManager.shared.authorizationStatus == .notDetermined)")
        self.display(.populated)
    }
    
}

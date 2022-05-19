//
//  DiscoveryViewPresenter.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation

struct DiscoveryState {
    enum DiscoveryMode {
        case map
        case list
    }
    
    var activeMode: DiscoveryMode?
    var desiredMode = DiscoveryMode.map
}

class DiscoveryViewPresenter: Presentable {
    var viewModel = DiscoveryState()
    var error: Error?
    var display: DisplayLogic
    
    required init(display: @escaping DisplayLogic) {
        self.display = display
    }
    
    func setup() {
        self.display(.populated)
    }
    
    /// Used to inform the State that the active mode has been updated to the desired mode, will not trigger a display update
    func activeModeUpdatedToDesired() {
        self.viewModel.activeMode = self.viewModel.desiredMode
    }
    
    func updateDesiredMode(_ mode: State.DiscoveryMode) {
        self.viewModel.desiredMode = mode
        self.display(.populated)
    }
}

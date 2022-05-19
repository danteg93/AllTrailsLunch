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
    var desiredMode = DiscoveryMode.list
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
        let arguments = NearbyRestaurantsArguments(keyword: nil)
        // Will trigger a search, which will update the cache.
        // Observers to the cache will be updated with the latest search results
        NearbyRestaurantsEntity.asyncRequest(arguments: arguments) { _ in }
    }
    
    /// Used to inform the State that the active mode has been updated to the desired mode, will not trigger a display update
    func activeModeUpdatedToDesired() {
        self.viewModel.activeMode = self.viewModel.desiredMode
    }
    
    func updateDesiredMode(_ mode: State.DiscoveryMode) {
        self.viewModel.desiredMode = mode
        self.display(.populated)
    }
    
    func searchNearbyPlaces(_ keyword: String?) {
        let arguments = NearbyRestaurantsArguments(keyword: keyword)
        // Will trigger a search, which will update the cache.
        // Observers to the cache will be updated with the latest search results
        NearbyRestaurantsEntity.asyncRequest(arguments: arguments) { _ in }
    }
}

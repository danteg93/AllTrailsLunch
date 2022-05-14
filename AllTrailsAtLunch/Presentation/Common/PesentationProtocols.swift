//
//  PesentationProtocols.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/14/22.
//

import Foundation
import UIKit

enum DisplayableState {
    case stateNotRequested
    case empty
    case loading
    case error
    case populated
}

typealias DisplayLogic = (_ displayState: DisplayableState) -> Void

protocol Presentable: AnyObject {
    // This is the ViewModel State for a particular scene
    associatedtype State
    
    var viewModel: State { get set }
    var error: Error? { get set }
    var display: DisplayLogic { get set }
    init(display: @escaping DisplayLogic)
}

protocol Displayable: AnyObject {
    associatedtype State
    associatedtype Presenter: Presentable where Presenter.State == Self.State
    
    var presenter: Presenter? { get set }
    
    func display(_ displayableState: DisplayableState)
}

extension Displayable {
    func createPresenter() {
        self.presenter = Presenter.init { [weak self] state in
            self?.display(state)
        }
    }
}

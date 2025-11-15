//
//  BaseModulesRules.swift
//  ABOL
//
//  Created by user on 27.11.2021.
//  Copyright © 2021 ps. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerRules: AnyObject {
    
    associatedtype Presenter
    associatedtype ViewState
    
    var presenter: Presenter { get }
    
    func setViewState(_ viewState: ViewState)
}

protocol PresenterRules {
    
    associatedtype ViewController
    associatedtype ViewState
    associatedtype Action
    associatedtype ViewMutation
    associatedtype Reducer
    
    var viewController: ViewController? { get }
    var viewState: ViewState { get }
    var reducer: Reducer { get }
    
    func handle(_ action: Action)
    func apply(_ viewMutations: [ViewMutation])
}

protocol ReducerRules {
    
    associatedtype ViewState
    associatedtype ViewMutation
    
    func getNewViewState(oldViewState: ViewState, viewMutations: [ViewMutation]) -> ViewState
}

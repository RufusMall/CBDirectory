//
//  BaseViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 01/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation

public protocol CreateDefault {
    associatedtype ViewState
    static func `default`() -> ViewState
}

public protocol ViewModelProtocol {
    associatedtype ViewState
    
    typealias ViewStateChanged = (ViewState)->()
    var stateChanged: ViewStateChanged? { get set }

    func start()
}

open class ViewModel<TViewState: CreateDefault>: ViewModelProtocol {
    public var stateChanged: ViewStateChanged?
    public typealias ViewState = TViewState
    
    public init(stateChanged: ViewStateChanged? = nil) {
        self.stateChanged = stateChanged
        state = TViewState.default() as! TViewState
    }
    
    public var state: TViewState {
        didSet {
            self.stateChanged?(state)
        }
    }
    
    /// Default start function fires state changed handler to propogate initial state
    open func start() {
        self.stateChanged?(state)
    }
}

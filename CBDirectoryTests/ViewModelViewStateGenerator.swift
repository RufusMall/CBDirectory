//
//  ViewModelViewStateGenerator.swift
//  CBDirectoryTests
//
//  Created by Rufus on 02/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation
import XCTest

/// This generates an ordered list of ViewState
class ViewModelViewStateGenerator<TViewModel> where TViewModel : ViewModelProtocol {
    
    var viewModel: TViewModel
    
    init(viewModel: TViewModel) {
        self.viewModel = viewModel
    }
    
    /// Simulates actions on the view model and collects the view state to be inspected.
    /// - Parameters:
    ///   - expectation: expectation should be configured with the expectedFulfillmentCount set
    ///   - viewModelActions: simulate inputs on the view model. By default this just starts the view model
    ///   - timeout: timeout for expection in seconds. Defaults to 10.0
    func waitForViewStateFulfilling(expectation: XCTestExpectation, timeout: Double = 10.0, viewModelActions: (()->())? = nil) -> [TViewModel.ViewState] {
        var viewState = [TViewModel.ViewState]()
     
        viewModel.stateChanged = { state in
            viewState.append(state)
            expectation.fulfill()
        }
        if let vmActions = viewModelActions  {
            vmActions()
        } else {
            viewModel.start()
        }
        
        let waiter = XCTWaiter()
        waiter.wait(for: [expectation], timeout: timeout)
        return viewState
    }
}

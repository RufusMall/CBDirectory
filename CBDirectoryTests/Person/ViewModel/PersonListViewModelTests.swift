//
//  PersonListViewModelTests.swift
//  CBDirectoryTests
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import XCTest
import People
import Common
@testable import CBDirectory

class PersonListViewModelTests: XCTestCase {
    
    func test_loadPeopleFlowSuceed() {
        
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        let viewModel = PersonListViewModel(service: MockPersonService())
        let stateTracker = ViewModelViewStateGenerator(viewModel: viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation)
        
        let initialState = viewStates[0]
        XCTAssertEqual(initialState.title, "People")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.people.count, 0)
        XCTAssertEqual(initialState.searchTextPlaceholder, "Search using a persons name or job.")
        
        let loadCompleteState = viewStates[1]
        XCTAssertEqual(loadCompleteState.title, "People")
        XCTAssertEqual(loadCompleteState.errorMessage, nil)
        XCTAssertEqual(loadCompleteState.people.count, 26)
        XCTAssertEqual(initialState.searchTextPlaceholder, "Search using a persons name or job.")
    }
    
    func test_loadPeopleFlowServerError() {
        
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        let personService = MockPersonService(forceErrorAfterNAttempts: 0)
        let viewModel = PersonListViewModel(service: personService)
        
        let stateTracker = ViewModelViewStateGenerator(viewModel: viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation)
        
        let initialState = viewStates[0]
        XCTAssertEqual(initialState.title, "People")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.people.count, 0)
        
        let loadCompleteState = viewStates[1]
        XCTAssertEqual(loadCompleteState.title, "People")
        XCTAssertEqual(loadCompleteState.errorMessage, "Server returned an unexpected result. Please try again.")
        XCTAssertEqual(loadCompleteState.people.count, 0)
    }
    
    func test_loadPeopleFlowEnsureCurrentlyLoadedItemsNotClearedIfFutureRequestsFail() {
        
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 3
        
        let personService = MockPersonService(forceErrorAfterNAttempts: 1)
        let viewModel = PersonListViewModel(service: personService)
        
        let stateTracker = ViewModelViewStateGenerator(viewModel: viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation, viewModelActions: {
            viewModel.start()
            viewModel.refresh()
        })
        
        let initialState = viewStates[0]
        XCTAssertEqual(initialState.title, "People")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.people.count, 0)
        
        let firstLoad = viewStates[1]
        XCTAssertEqual(firstLoad.title, "People")
        XCTAssertEqual(firstLoad.errorMessage, nil)
        XCTAssertEqual(firstLoad.people.count, 26)
        
        let secondLoad = viewStates[2]
        XCTAssertEqual(secondLoad.title, "People")
        XCTAssertEqual(secondLoad.errorMessage, "Server returned an unexpected result. Please try again.")
        XCTAssertEqual(secondLoad.people.count, 26)
    }
    
    func test_loadPeopleOrderResultsByLastName() {
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        let viewModel = PersonListViewModel(service: MockPersonService())
        let stateTracker = ViewModelViewStateGenerator(viewModel: viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation)
        
        let initialState = viewStates[0]
        XCTAssertEqual(initialState.title, "People")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.people.count, 0)
        
        let loadCompleteState = viewStates[1]
        XCTAssertEqual(loadCompleteState.title, "People")
        XCTAssertEqual(loadCompleteState.errorMessage, nil)
        XCTAssertEqual(loadCompleteState.people.count, 26)
        
        XCTAssertEqual(loadCompleteState.people[0].state.lastName, "last a")
        XCTAssertEqual(loadCompleteState.people[1].state.lastName, "last b")
        XCTAssertEqual(loadCompleteState.people[2].state.lastName, "last c")
    }
}

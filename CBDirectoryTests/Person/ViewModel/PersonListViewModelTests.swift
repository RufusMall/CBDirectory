//
//  PersonListViewModelTests.swift
//  CBDirectoryTests
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import XCTest
@testable import CBDirectory

class PersonListViewModelTests: XCTestCase {
 
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func test_loadPeopleFlowSuceed() {
        
        var viewState = [PersonListViewModel.State]()
        
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 2
        
        let viewModel = PersonListViewModel(service: MockPersonService(), stateChanged: { (state) in
            viewState.append(state)
            
            expectation.fulfill()
        })
        
        viewModel.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        let initialState = viewState[0]
        XCTAssertEqual(initialState.title, "People")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.people.count, 0)
        
        let loadCompleteState = viewState[1]
        XCTAssertEqual(loadCompleteState.title, "People")
        XCTAssertEqual(loadCompleteState.errorMessage, nil)
        XCTAssertEqual(loadCompleteState.people.count, 50)
    }
    
    func test_loadPeopleFlowServerError() {
        
        var viewState = [PersonListViewModel.State]()
        
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 2
        
        let personService = MockPersonService(forceErrorAfterNAttempts: 0)
        let viewModel = PersonListViewModel(service: personService, stateChanged: { (state) in
            viewState.append(state)
            
            expectation.fulfill()
        })
        
        viewModel.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        let initialState = viewState[0]
        XCTAssertEqual(initialState.title, "People")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.people.count, 0)
        
        let loadCompleteState = viewState[1]
        XCTAssertEqual(loadCompleteState.title, "People")
        XCTAssertEqual(loadCompleteState.errorMessage, "Server returned an unexpected result. Please try again.")
        XCTAssertEqual(loadCompleteState.people.count, 0)
    }
    
    func test_loadPeopleFlowEnsureCurrentlyLoadedItemsNotClearedIfFutureRequestsFail() {
        var viewState = [PersonListViewModel.State]()
        
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 3
        
        let personService = MockPersonService(forceErrorAfterNAttempts: 1)
        let viewModel = PersonListViewModel(service: personService, stateChanged: { (state) in
            viewState.append(state)
            
            expectation.fulfill()
        })
        
        viewModel.start()
        viewModel.refresh()
        
        waitForExpectations(timeout: 5.0, handler: nil)
        
        let initialState = viewState[0]
        XCTAssertEqual(initialState.title, "People")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.people.count, 0)
        
        let firstLoad = viewState[1]
        XCTAssertEqual(firstLoad.title, "People")
        XCTAssertEqual(firstLoad.errorMessage, nil)
        XCTAssertEqual(firstLoad.people.count, 50)
        
        let secondLoad = viewState[2]
        XCTAssertEqual(secondLoad.title, "People")
        XCTAssertEqual(secondLoad.errorMessage, "Server returned an unexpected result. Please try again.")
        XCTAssertEqual(secondLoad.people.count, 50)
    }
    
    func test_FAILCITEST() {
           XCTAssertEqual(true, false)
       }
}

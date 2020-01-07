//
//  PersonListViewModelTests.swift
//  CBDirectoryTests
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import XCTest
@testable import CBDirectory
import Common
import Rooms

class RoomListViewModelTests: XCTestCase {
    
    func test_roomFlowSuceeded() {
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        let viewModel = RoomListViewModel(service: MockRoomService())
        let stateTracker = ViewModelViewStateGenerator(viewModel:viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation)
        
        let initialState = viewStates[0]
        XCTAssertEqual(initialState.title, "Rooms")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.rooms.count, 0)
        
        let loadCompleteState = viewStates[1]
        XCTAssertEqual(loadCompleteState.title, "Rooms")
        XCTAssertEqual(loadCompleteState.errorMessage, nil)
        XCTAssertEqual(loadCompleteState.rooms.count, 50)
    }
    
    func test_loadRoomFlowServerError() {
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        let viewModel = RoomListViewModel(service: MockRoomService(forceErrorAfterNAttempts: 0))
        let stateTracker = ViewModelViewStateGenerator(viewModel:viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation)
        
        let initialState = viewStates[0]
        XCTAssertEqual(initialState.title, "Rooms")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.rooms.count, 0)
        
        let loadCompleteState = viewStates[1]
        XCTAssertEqual(loadCompleteState.title, "Rooms")
        XCTAssertEqual(loadCompleteState.errorMessage, "Server returned an unexpected result. Please try again.")
        XCTAssertEqual(loadCompleteState.rooms.count, 0)
    }
    
    func test_loadRoomsFlowEnsureCurrentlyLoadedItemsNotClearedIfFutureRequestsFail() {
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 3
        
        let roomService = MockRoomService(forceErrorAfterNAttempts: 1)
        let viewModel = RoomListViewModel(service: roomService)
        
        let stateTracker = ViewModelViewStateGenerator(viewModel:viewModel)
        
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation) {
            viewModel.start()
            viewModel.refresh()
        }
        
        let initialState = viewStates[0]
        XCTAssertEqual(initialState.title, "Rooms")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.rooms.count, 0)
        
        let firstLoad = viewStates[1]
        XCTAssertEqual(firstLoad.title, "Rooms")
        XCTAssertEqual(firstLoad.errorMessage, nil)
        XCTAssertEqual(firstLoad.rooms.count, 50)
        
        
        let postRefreshViewStates = viewStates[2]
        XCTAssertEqual(postRefreshViewStates.title, "Rooms")
        XCTAssertEqual(postRefreshViewStates.errorMessage, "Server returned an unexpected result. Please try again.")
        XCTAssertEqual(postRefreshViewStates.rooms.count, 50)
    }
}

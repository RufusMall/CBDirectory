//
//  PersonListViewModelTests.swift
//  CBDirectoryTests
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import XCTest
@testable import CBDirectory

class RoomListViewModelTests: XCTestCase {
    
    func test_roomFlowSuceeded() {
        
        var viewState = [RoomListViewModel.State]()
        
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        let viewModel = RoomListViewModel(service: MockRoomService(), stateChanged: { (state) in
            viewState.append(state)
            expectation.fulfill()
        })
        
        viewModel.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        let initialState = viewState[0]
        XCTAssertEqual(initialState.title, "Rooms")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.rooms.count, 0)
        
        let loadCompleteState = viewState[1]
        XCTAssertEqual(loadCompleteState.title, "Rooms")
        XCTAssertEqual(loadCompleteState.errorMessage, nil)
        XCTAssertEqual(loadCompleteState.rooms.count, 50)
    }
    
    func test_loadRoomFlowServerError() {
        
        var viewState = [RoomListViewModel.State]()
        
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        let roomService = MockRoomService(forceErrorAfterNAttempts: 0)
        let viewModel = RoomListViewModel(service: roomService, stateChanged: { (state) in
            viewState.append(state)
            
            expectation.fulfill()
        })
        
        viewModel.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        let initialState = viewState[0]
        XCTAssertEqual(initialState.title, "Rooms")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.rooms.count, 0)
        
        let loadCompleteState = viewState[1]
        XCTAssertEqual(loadCompleteState.title, "Rooms")
        XCTAssertEqual(loadCompleteState.errorMessage, "Server returned an unexpected result. Please try again.")
        XCTAssertEqual(loadCompleteState.rooms.count, 0)
    }
    
    func test_loadRoomsFlowEnsureCurrentlyLoadedItemsNotClearedIfFutureRequestsFail() {
        var viewState = [RoomListViewModel.State]()
        
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 3
        
        let roomService = MockRoomService(forceErrorAfterNAttempts: 1)
        let viewModel = RoomListViewModel(service: roomService, stateChanged: { (state) in
            viewState.append(state)
            expectation.fulfill()
        })
        
        viewModel.start()
        viewModel.refresh()
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
        let initialState = viewState[0]
        XCTAssertEqual(initialState.title, "Rooms")
        XCTAssertEqual(initialState.errorMessage, nil)
        XCTAssertEqual(initialState.rooms.count, 0)
        
        let firstLoad = viewState[1]
        XCTAssertEqual(firstLoad.title, "Rooms")
        XCTAssertEqual(firstLoad.errorMessage, nil)
        XCTAssertEqual(firstLoad.rooms.count, 50)
        
        let secondLoad = viewState[2]
        XCTAssertEqual(secondLoad.title, "Rooms")
        XCTAssertEqual(secondLoad.errorMessage, "Server returned an unexpected result. Please try again.")
        XCTAssertEqual(secondLoad.rooms.count, 50)
    }
}

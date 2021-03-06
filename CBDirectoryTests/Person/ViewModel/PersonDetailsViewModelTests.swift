//
//  PersonDetailsViewModelTest.swift
//  CBDirectoryTests
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import XCTest
import Common
import People
@testable import CBDirectory

class PersonDetailsViewModelTests: XCTestCase {
    
    let testPersonInvalidImgURL = Person(id: "id", createdAt: "", avatar: "avatarURL", jobTitle: "jobTitle", phone: "01698386326", favouriteColor: "color", email: "Mike@email.com", firstName: "Mike", lastName: "Anderson")
    
    let testPersonValidImgURL = Person(id: "id", createdAt: "", avatar: "https://s3.amazonaws.com/uifaces/faces/twitter/lingeswaran/128.jpg", jobTitle: "jobTitle", phone: "01698386326", favouriteColor: "color", email: "Mike@email.com", firstName: "Mike", lastName: "Anderson")
    
    func test_initialState() {
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 3
        let viewModel = PersonDetailsViewModel(personService: MockPersonService(), personID: "2")
        let stateTracker = ViewModelViewStateGenerator(viewModel: viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation)
        
        let initialState = viewStates[0]
        
        XCTAssertEqual("Loading...", initialState.title)
        XCTAssertNil(initialState.errorMessage)
        XCTAssertNil(initialState.avatar)
        XCTAssert(initialState.dataItems.count == 0)
    }
    
    func test_personDetailsLoaded() {
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 3
        
        let viewModel = PersonDetailsViewModel(personService: MockPersonService(), personID: "2")
        
        let stateTracker = ViewModelViewStateGenerator(viewModel: viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation)
        
        let personLoadedState = viewStates[2]
        let itemViewModels = personLoadedState.dataItems
        XCTAssertEqual("first_name last_name", personLoadedState.title)
        XCTAssertNil(personLoadedState.errorMessage)
        XCTAssertNotNil(personLoadedState.avatar)
        assert(viewModel:itemViewModels[0], has: "first name:", content: "first_name")
        assert(viewModel:itemViewModels[1], has: "last name:", content: "last_name")
        assert(viewModel:itemViewModels[2], has: "phone:", content: "phonenumber")
        assert(viewModel:itemViewModels[3], has: "email:", content: "email@email.com")
        assert(viewModel:itemViewModels[4], has: "job title:", content: "Engineer")
    }
    
    func test_networkError() {
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        let viewModel = PersonDetailsViewModel(personService: MockPersonService(forceErrorAfterNAttempts: 0), personID: "2")
        
        let stateTracker = ViewModelViewStateGenerator(viewModel: viewModel)
        let viewState = stateTracker.waitForViewStateFulfilling(expectation: expectation)
        
        let personLoadState = viewState[1]
        
        XCTAssertEqual("Load Failed", personLoadState.title)
        XCTAssertEqual("Server returned an unexpected result. Please try again.", personLoadState.errorMessage)
        XCTAssertNil(personLoadState.avatar)
        XCTAssert(personLoadState.dataItems.count == 0)
    }
    
    func assert(viewModel: DataItemCellViewModel, has title: String, content: String) {
        XCTAssertEqual(viewModel.title, title)
        XCTAssertEqual(viewModel.content, content)
    }
}

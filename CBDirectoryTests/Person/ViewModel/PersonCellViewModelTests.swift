//
//  PersonDetailsViewModelTest.swift
//  CBDirectoryTests
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import XCTest
@testable import CBDirectory

class PersonCellViewModelTests: XCTestCase {
    
    let testPersonInvalidImgURL = Person(id: "id", createdAt: "", avatar: "avatarURL", jobTitle: "jobTitle", phone: "01698386326", favouriteColor: "color", email: "Mike@email.com", firstName: "Mike", lastName: "Anderson")
    
    let testPersonValidImgURL = Person(id: "id", createdAt: "", avatar: "https://s3.amazonaws.com/uifaces/faces/twitter/lingeswaran/128.jpg", jobTitle: "jobTitle", phone: "01698386326", favouriteColor: "color", email: "Mike@email.com", firstName: "Mike", lastName: "Anderson")
    
    func test_flowInvalidImageURL() {
        var viewState = [PersonCellViewModel.State]()
        
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 1
        
        let testPerson = testPersonInvalidImgURL
        let viewModel = PersonCellViewModel(person: testPerson)
        
        viewModel.stateChanged = { state in
            viewState.append(state)
            expectation.fulfill()
        }
        
        viewModel.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        let initialState = viewState[0]
        assert(state: initialState, isConfiguredFor: testPerson, usingImage: PersonCellViewModel.placeholderImage)
    }
    
    func test_flowValidImageURL() {
        
        var viewState = [PersonCellViewModel.State]()
        
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 2
        
        let testPerson = testPersonValidImgURL
        let viewModel = PersonCellViewModel(person: testPerson)
        
        viewModel.stateChanged = { state in
            viewState.append(state)
            expectation.fulfill()
        }
        
        viewModel.start()
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
        let initialState = viewState[0]
        assert(state: initialState, isConfiguredFor: testPerson, usingImage: PersonCellViewModel.placeholderImage)
        
        let imageFetchComplete = viewState[1]
        XCTAssertNotEqual(imageFetchComplete.avatar, PersonCellViewModel.placeholderImage)
        XCTAssertEqual(imageFetchComplete.firstName, testPersonInvalidImgURL.firstName)
        XCTAssertEqual(imageFetchComplete.lastName, testPersonInvalidImgURL.lastName)
    }
    
    func assert(state:PersonCellViewModel.State, isConfiguredFor person: Person, usingImage image: UIImage) {
        XCTAssertEqual(state.avatar, image)
        XCTAssertEqual(state.firstName, testPersonInvalidImgURL.firstName)
        XCTAssertEqual(state.lastName, testPersonInvalidImgURL.lastName)
    }
}

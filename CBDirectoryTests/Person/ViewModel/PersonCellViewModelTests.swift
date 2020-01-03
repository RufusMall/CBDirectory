//
//  PersonDetailsViewModelTest.swift
//  CBDirectoryTests
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import XCTest
@testable import CBDirectory

extension PersonCellViewModel: ViewModelProtocol {}

class PersonCellViewModelTests: XCTestCase {
    
    let testPersonInvalidImgURL = Person(id: "id", createdAt: "", avatar: "avatarURL", jobTitle: "jobTitle", phone: "01698386326", favouriteColor: "color", email: "Mike@email.com", firstName: "Mike", lastName: "Anderson")
    
    let testPersonValidImgURL = Person(id: "id", createdAt: "", avatar: "https://s3.amazonaws.com/uifaces/faces/twitter/lingeswaran/128.jpg", jobTitle: "jobTitle", phone: "01698386326", favouriteColor: "color", email: "Mike@email.com", firstName: "Mike", lastName: "Anderson")
    
    func test_flowInvalidImageURL() {
        
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 1
        
        let testPerson = testPersonInvalidImgURL
        let viewModel = PersonCellViewModel(person: testPerson)
        let stateTracker = ViewModelViewStateGenerator(viewModel:viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation)
        
        let initialState = viewStates[0]
        assert(state: initialState, isConfiguredFor: testPerson, usingImage: PersonCellViewModel.placeholderImage)
    }
    
    func test_flowValidImageURL() {
        
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        let testPerson = testPersonValidImgURL
        let viewModel = PersonCellViewModel(person: testPerson)
        let stateTracker = ViewModelViewStateGenerator(viewModel:viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation)
        
        let initialState = viewStates[0]
        assert(state: initialState, isConfiguredFor: testPerson, usingImage: PersonCellViewModel.placeholderImage)
        
        let imageFetchComplete = viewStates[1]
        XCTAssertNotEqual(imageFetchComplete.avatar, PersonCellViewModel.placeholderImage)
        XCTAssertEqual(imageFetchComplete.firstName, testPersonInvalidImgURL.firstName)
        XCTAssertEqual(imageFetchComplete.lastName, testPersonInvalidImgURL.lastName)
    }
    
    func assert(state:PersonCellViewState, isConfiguredFor person: Person, usingImage image: UIImage) {
        XCTAssertEqual(state.avatar, image)
        XCTAssertEqual(state.firstName, testPersonInvalidImgURL.firstName)
        XCTAssertEqual(state.lastName, testPersonInvalidImgURL.lastName)
    }
}

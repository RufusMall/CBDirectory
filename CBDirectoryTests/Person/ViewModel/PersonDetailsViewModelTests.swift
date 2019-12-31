//
//  PersonDetailsViewModelTest.swift
//  CBDirectoryTests
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import XCTest
import CBDirectory

class PersonDetailsViewModelTests: XCTestCase {
    
    let testPersonInvalidImgURL = Person(id: "id", createdAt: "", avatar: "avatarURL", jobTitle: "jobTitle", phone: "01698386326", favouriteColor: "color", email: "Mike@email.com", firstName: "Mike", lastName: "Anderson")
    
    let testPersonValidImgURL = Person(id: "id", createdAt: "", avatar: "https://s3.amazonaws.com/uifaces/faces/twitter/lingeswaran/128.jpg", jobTitle: "jobTitle", phone: "01698386326", favouriteColor: "color", email: "Mike@email.com", firstName: "Mike", lastName: "Anderson")
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func test_initialState() {
        var viewState = [PersonDetailsViewModel.State]()
        
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 1
        
        let viewModel = PersonDetailsViewModel(personService: MockPersonService(), personID: "2") { (state) in
            viewState.append(state)
            expectation.fulfill()
        }
        
        viewModel.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        let initialState = viewState[0]
        
        XCTAssert(initialState.isLoading)
        XCTAssertEqual("Loading...", initialState.title)
        print(initialState)
    }
}

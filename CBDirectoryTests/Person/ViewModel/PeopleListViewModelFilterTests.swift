//
//  PeopleListFilterTests.swift
//  CBDirectoryTests
//
//  Created by Rufus on 03/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import XCTest
@testable import CBDirectory

class PeopleListFilterTests: XCTestCase {

      func test_searchFilterInitialCount() {
        let viewModel = createViewModelWithInitialResults(service: MockPersonFileSystemService())
        XCTAssertEqual(viewModel.state.people.count, 50)
        XCTAssertNil(viewModel.searchFilter)
        
        let filteredPeople = runSearchFilterTest(searchString: "ry", viewModel: viewModel)
        XCTAssertEqual(filteredPeople[0].firstName, "Ryan")
        XCTAssertEqual(filteredPeople[0].lastName, "Oberbrunner")
        XCTAssertEqual(filteredPeople[1].firstName, "Dovie")
        XCTAssertEqual(filteredPeople[1].lastName, "Terry")
        XCTAssertEqual(filteredPeople[2].firstName, "Ryder")
        XCTAssertEqual(filteredPeople[2].lastName, "Toy")
    }
    
    func test_searchFilterCaseInsensitives() {
        let viewModel = createViewModelWithInitialResults(service: MockPersonFileSystemService())
        XCTAssertEqual(viewModel.state.people.count, 50)
        
        var filteredPeople = runSearchFilterTest(searchString: "RYAN", viewModel: viewModel)
        XCTAssertEqual(filteredPeople[0].firstName, "Ryan")
        XCTAssertEqual(filteredPeople[0].lastName, "Oberbrunner")
        
        filteredPeople = runSearchFilterTest(searchString: "ryan", viewModel: viewModel)
        XCTAssertEqual(filteredPeople[0].firstName, "Ryan")
        XCTAssertEqual(filteredPeople[0].lastName, "Oberbrunner")
    }
    
    func test_searchFilterResetsOnEmptyString() {
        let viewModel = createViewModelWithInitialResults(service: MockPersonFileSystemService())
        XCTAssertEqual(viewModel.state.people.count, 50)
        
        var filteredPeople = runSearchFilterTest(searchString: "RYAN", viewModel: viewModel)
        XCTAssertEqual(filteredPeople[0].firstName, "Ryan")
        XCTAssertEqual(filteredPeople[0].lastName, "Oberbrunner")
        
        filteredPeople = runSearchFilterTest(searchString: "", viewModel: viewModel)
        
        XCTAssertEqual(filteredPeople.count, 50)
    }
    
    func test_searchFilterResetsOnNilFilter() {
        let viewModel = createViewModelWithInitialResults(service: MockPersonFileSystemService())
        XCTAssertEqual(viewModel.state.people.count, 50)
        
        var filteredPeople = runSearchFilterTest(searchString: "RYAN", viewModel: viewModel)
        XCTAssertEqual(filteredPeople[0].firstName, "Ryan")
        XCTAssertEqual(filteredPeople[0].lastName, "Oberbrunner")
        
        filteredPeople = runSearchFilterTest(searchString: nil, viewModel: viewModel)
        
        XCTAssertEqual(filteredPeople.count, 50)
    }
    
    func test_searchFilterCanSearchJobs() {
          let viewModel = createViewModelWithInitialResults(service: MockPersonFileSystemService())
          XCTAssertEqual(viewModel.state.people.count, 50)
          
          let filteredPeople = runSearchFilterTest(searchString: "Engi", viewModel: viewModel)
          XCTAssertEqual(filteredPeople[0].firstName, "Laura")
          XCTAssertEqual(filteredPeople[0].lastName, "Kulas")
          XCTAssertEqual(filteredPeople[0].jobTitle, "Investor Usability Engineer")
          
          XCTAssertEqual(filteredPeople.count, 1)
      }
    
    func runSearchFilterTest(searchString: String?, viewModel:PersonListViewModel) -> [PersonCellViewModel.ViewState] {
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 1
        let stateTracker = ViewModelViewStateGenerator(viewModel: viewModel)
        let viewStates = stateTracker.waitForViewStateFulfilling(expectation: expectation, timeout: 10) {
            viewModel.searchFilter = searchString
        }
        return viewStates[0].people.map{$0.state}
    }
    
    func createViewModelWithInitialResults(service:PersonServiceProtocol) -> PersonListViewModel{
        let populateUnfiliteredItems = self.expectation()
        populateUnfiliteredItems.expectedFulfillmentCount = 2
        let viewModel = PersonListViewModel(service: service){ state in
            populateUnfiliteredItems.fulfill()
        }
        viewModel.start()
        wait(for: [populateUnfiliteredItems], timeout: 2.0)
        
        return viewModel
    }
}

//
//  PersonViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 24/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation

public struct PersonListViewState: CreateDefault {
    public typealias ViewState = PersonListViewState
    
    public static func `default`() -> PersonListViewState {
        return ViewState()
    }
    
    public let title = "People"
    public var errorMessage: String?
    public var people = [PersonCellViewModel]()
}

public class PersonListViewModel: ViewModel<PersonListViewState> {
    private let service: PersonServiceProtocol
    
    public init(service: PersonServiceProtocol, stateChanged: ((PersonListViewState)->())? = nil) {
        self.service = service
        super.init(stateChanged: stateChanged)
    }
    
    public override func start() {
        super.start()
        fetchPeople()
    }
    
    public func refresh() {
        fetchPeople()
    }
    
    private func fetchPeople() {
        service.fetchPeople { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let people):
                    let personViewModels = people.map { (person) -> PersonCellViewModel in
                        return PersonCellViewModel(person: person)
                    }
                    
                    let sortedViewModels = personViewModels.sorted { (p1, p2) -> Bool in
                        return p1.state.lastName < p2.state.lastName
                    }
                    
                    self.state = PersonListViewState(errorMessage: nil, people: sortedViewModels)
                case .failure(let error):
                    //continue to show old people. Should really improve this so we show some sort of error + existing fetched people
                    self.state = PersonListViewState(errorMessage: error.localizedDescription, people: self.state.people)
                    print(error.localizedDescription)
                }
            }
        }
    }
}

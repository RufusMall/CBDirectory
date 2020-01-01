//
//  PersonViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 24/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation

public class PersonListViewModel {
    public struct State {
        public let title = "People"
        public var errorMessage: String?
        public var people = [PersonCellViewModel]()
    }
    
    private let service: PersonServiceProtocol
    private let stateChanged: (State)->()
    
    public var state = State() {
        didSet {
            self.stateChanged(state)
        }
    }
    
    public init(service: PersonServiceProtocol, stateChanged:@escaping (State)->()) {
        self.stateChanged = stateChanged
        self.service = service
    }
    
    public func start() {
        self.stateChanged(state)
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
                    
                    self.state = State(errorMessage: nil, people: sortedViewModels)
                case .failure(let error):
                    //continue to show old people. Should really improve this so we show some sort of error + existing fetched people
                    self.state = State(errorMessage: error.localizedDescription, people: self.state.people)
                    print(error.localizedDescription)
                }
            }
        }
    }
}

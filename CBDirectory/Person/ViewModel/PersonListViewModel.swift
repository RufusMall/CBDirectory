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
    
    let service: PersonServiceProtocol
    let stateChanged: (State)->()
    
    var state = State() {
        didSet {
            self.stateChanged(state)
        }
    }
    
    public init(service: PersonServiceProtocol, stateChanged:@escaping (State)->()) {
        self.stateChanged = stateChanged
        self.service = service
    }
    
    func start() {
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
                    self.state = State(errorMessage: nil, people: personViewModels)
                case .failure(let error):
                    self.state = State(errorMessage: error.localizedDescription, people: self.state.people)
                    print(error.localizedDescription)
                }
            }
        }
    }
}

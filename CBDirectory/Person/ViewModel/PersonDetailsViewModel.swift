//
//  PersonDetailsViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation

public class PersonDetailsViewModel {
    
    var personService: PersonServiceProtocol
    var selectedPersonID: String
    
    public struct State {
        public var title: String
        public var isLoading: Bool
        public var errorMessage: String?
    }
    
    let stateChanged: (State)->()
    
    var state: State {
        didSet {
            self.stateChanged(state)
        }
    }
    
    public init(personService: PersonServiceProtocol, personID: String, stateChanged: @escaping (State)->()) {
        self.stateChanged = stateChanged
        self.personService = personService
        selectedPersonID = personID
        self.state = State(title: "Loading...", isLoading: true)
    }
    
    public func start() {
        self.stateChanged(state)
        self.personService.fetchPerson(id: selectedPersonID) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let personDetails):
                    self.state.title = "\(personDetails.firstName)"
                case .failure(let error):
                    self.state.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

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
    
    public struct State {
        public let title: String
        public let isLoading: Bool
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
        self.state = State(title: "Loading...", isLoading: true)
    }
    
    public func start() {
        self.stateChanged(state)
    }
}

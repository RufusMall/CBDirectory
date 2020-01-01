//
//  PersonService.swift
//  CBDirectory
//
//  Created by Rufus on 24/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation

public protocol PersonServiceProtocol {
    typealias PeopleCompletion = (Result<[Person],Error>)->()
    typealias PersonCompletion = (Result<PersonDetails,Error>)->()
    func fetchPeople(completion:@escaping PeopleCompletion)
    func fetchPerson(id: String, completion: @escaping PersonCompletion)
}

public class PersonService: BaseService, PersonServiceProtocol {
    
    /// fetch list of people
    /// - Parameter completion: provides a list of PEOPLE. This returns on a background thread
    public func fetchPeople(completion: @escaping PeopleCompletion) {
        super.get(route: "people", completion: completion)
    }
    
    /// fetch a person by ID
    /// - Parameter completion: provides a person. This returns on a background thread
    public func fetchPerson(id: String, completion: @escaping PersonCompletion) {
        super.get(route: "people/\(id)", completion: completion)
    }
}

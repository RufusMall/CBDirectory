//
//  PersonServiceMock.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation

public class MockPersonService: BaseMockService, PersonServiceProtocol {
    
    public func fetchPeople(completion:@escaping PeopleCompletion) {
        var people = [Person]()
        
        for char in "abcdefghijklmnopqrstuvwxyz" {
            let i = char
            let strID = "\(i)"
            let strFirstName = "first \(i)"
            let strLasName = "last \(i)"
            let avatarURL = "https://s3.amazonaws.com/uifaces/faces/twitter/lingeswaran/128.jpg"
            let person = Person(id: strID, createdAt:Date().description, avatar: avatarURL, jobTitle: "Engineers", phone: strID, favouriteColor: strID, email: strID, firstName: strFirstName, lastName: strLasName)
            people.append(person)
        }
        executeCompletionOrSimulateError(object: people, completion: completion)
    }
    
    public func fetchPerson(id: String, completion: @escaping PersonCompletion) {
        let personDetails = PersonDetails(id: id, createdAt: "", avatar: "https://s3.amazonaws.com/uifaces/faces/twitter/lingeswaran/128.jpg", jobTitle: "Engineer", phone: "phonenumber", favouriteColor: "", email: "email@email.com", firstName: "first_name", lastName: "last_name")
        executeCompletionOrSimulateError(object: personDetails, completion: completion)
    }
}

public class MockPersonFileSystemService: BaseMockService, PersonServiceProtocol {
    let people: [Person]
    let personDetails: [PersonDetails]
    let delay = 0.8
    
    public init() {
        let personTestData = try! Data(contentsOf: Bundle(for: MockPersonFileSystemService.self).url(forResource: "people", withExtension: "json")!)
        let jsonDecoder = JSONDecoder()
        people = try! jsonDecoder.decode([Person].self, from: personTestData)
        personDetails = try! jsonDecoder.decode([PersonDetails].self, from: personTestData)
    }
    
    public func fetchPeople(completion: @escaping PeopleCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion(.success(self.people)) }
    }
    
    public func fetchPerson(id: String, completion: @escaping PersonCompletion) {
        
        let matchingPersonDetails = personDetails.first(where: {$0.id == id})!
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion(.success(matchingPersonDetails)) }
    }
}

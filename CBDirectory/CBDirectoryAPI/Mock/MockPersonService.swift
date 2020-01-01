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
        
        for i in 0..<50 {
            let strID = "\(i)"
            let strFirstName = "first_\(i)"
            let strLasName = "last_\(i)"
            let avatarURL = "https://s3.amazonaws.com/uifaces/faces/twitter/lingeswaran/128.jpg"
            let person = Person(id: strID, createdAt:Date().description, avatar: avatarURL, jobTitle: strID, phone: strID, favouriteColor: strID, email: strID, firstName: strFirstName, lastName: strLasName)
            people.append(person)
        }
        executeCompletionOrSimulateError(object: people, completion: completion)
    }
    
    public func fetchPerson(id: String, completion: @escaping PersonCompletion) {
        let personDetails = PersonDetails(id: id, createdAt: "", avatar: "https://s3.amazonaws.com/uifaces/faces/twitter/lingeswaran/128.jpg", jobTitle: "Engineer", phone: "phonenumber", favouriteColor: "", email: "email@email.com", firstName: "first_name", lastName: "last_name")
        executeCompletionOrSimulateError(object: personDetails, completion: completion)
    }
}

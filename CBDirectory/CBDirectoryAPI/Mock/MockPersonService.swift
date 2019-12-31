//
//  PersonServiceMock.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation

public class MockPersonService: PersonServiceProtocol {
    private var numAttemptsBeforeError: Int
    
    public init(forceErrorAfterNAttempts: Int = -1) {
        self.numAttemptsBeforeError = forceErrorAfterNAttempts
    }
    
    func shouldThrowError() -> Bool {
        return numAttemptsBeforeError == 0
    }
    
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
        let personDetails = PersonDetails(id: id, createdAt: "", avatar: "", jobTitle: "Engineer", phone: "phonenumber", favouriteColor: "", email: "", firstName: "first_name", lastName: "last_name")
        executeCompletionOrSimulateError(object: personDetails, completion: completion)
    }
    
    typealias ResultFunc<T> = (Result<T,Error>) -> ()
    
    func executeCompletionOrSimulateError<T>(object: T, completion:@escaping ResultFunc<T>) {
        let delay = 0.5
        if numAttemptsBeforeError == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion(.failure(WebClient.WebClientError.webResponseCodeError)) }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion(.success(object)) }
        }
        numAttemptsBeforeError -= 1
    }
}

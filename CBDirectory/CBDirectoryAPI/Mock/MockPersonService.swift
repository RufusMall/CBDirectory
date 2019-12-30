//
//  PersonServiceMock.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation

public class MockPersonService: PersonServiceProtocol {
    public typealias PersonCompletion = (Result<[Person],Error>)->()
    private var numAttemptsBeforeError: Int
    
    public init(forceErrorAfterNAttempts: Int = -1) {
        self.numAttemptsBeforeError = forceErrorAfterNAttempts
    }
    
    public func fetchPeople(completion:@escaping PersonCompletion) {
        var people = [Person]()
        
        for i in 0..<50 {
            let strID = "\(i)"
            let strFirstName = "first_\(i)"
            let strLasName = "last_\(i)"
            let avatarURL = "https://s3.amazonaws.com/uifaces/faces/twitter/lingeswaran/128.jpg"
            let person = Person(id: strID, createdAt:Date().description, avatar: avatarURL, jobTitle: strID, phone: strID, favouriteColor: strID, email: strID, firstName: strFirstName, lastName: strLasName)
            people.append(person)
        }
        
        if numAttemptsBeforeError == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.failure(WebClient.WebClientError.webResponseCodeError))
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(people))
            }
        }
        numAttemptsBeforeError -= 1
    }
}

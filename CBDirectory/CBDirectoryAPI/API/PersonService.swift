//
//  PersonService.swift
//  CBDirectory
//
//  Created by Rufus on 24/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation

public protocol PersonServiceProtocol {
    typealias PersonCompletion = (Result<[Person],Error>)->()
    func fetchPeople(completion:@escaping PersonCompletion)
}

public class PersonService: BaseService, PersonServiceProtocol {
    public func fetchPeople(completion: @escaping PersonCompletion) {
        super.get(route: "people", completion: completion)
    }
}

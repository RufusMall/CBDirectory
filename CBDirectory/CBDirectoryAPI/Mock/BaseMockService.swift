//
//  BaseMockService.swift
//  CBDirectory
//
//  Created by Rufus on 01/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation

public class BaseMockService {
    
    private var numAttemptsBeforeError: Int
    
    public init(forceErrorAfterNAttempts: Int = -1) {
        self.numAttemptsBeforeError = forceErrorAfterNAttempts
    }
    
    internal typealias ResultFunc<T> = (Result<T,Error>) -> ()
    
    internal func executeCompletionOrSimulateError<T>(object: T, completion:@escaping ResultFunc<T>) {
        let delay = 0.5
        if numAttemptsBeforeError == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion(.failure(WebClient.WebClientError.webResponseCodeError)) }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion(.success(object)) }
        }
        numAttemptsBeforeError -= 1
    }
}

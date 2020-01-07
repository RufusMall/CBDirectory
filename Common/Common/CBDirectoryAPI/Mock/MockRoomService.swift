//
//  PersonServiceMock.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation

public class MockRoomService: RoomServiceProtocol {
    private var numAttemptsBeforeError: Int
    
    public init(forceErrorAfterNAttempts: Int = -1) {
        self.numAttemptsBeforeError = forceErrorAfterNAttempts
    }
    
    public func fetchRooms(completion:@escaping RoomCompletion) {
        var rooms = [Room]()
        
        for i in 0..<50 {
            let isRoomOccupied = i % 2 == 0 ? true : false
            let room = Room(id: "\(i)", createdAt: "\(i)", name: "roomname_\(i)", isOccupied: isRoomOccupied)
            rooms.append(room)
        }
        executeCompletionOrSimulateError(object: rooms, completion: completion)
    }
    
    private typealias ResultFunc<T> = (Result<T,Error>) -> ()
    
    private func executeCompletionOrSimulateError<T>(object: T, completion:@escaping ResultFunc<T>) {
        let delay = 0.5
        if numAttemptsBeforeError == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion(.failure(WebClient.WebClientError.webResponseCodeError)) }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion(.success(object)) }
        }
        numAttemptsBeforeError -= 1
    }
}

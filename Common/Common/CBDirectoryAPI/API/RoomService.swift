//
//  RoomService.swift
//  CBDirectory
//
//  Created by Rufus on 01/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation

public protocol RoomServiceProtocol {
    typealias RoomCompletion = (Result<[Room],Error>)->()
    func fetchRooms(completion: @escaping RoomCompletion)
}

public class RoomService: BaseService, RoomServiceProtocol {
    
    /// fetch list of rooms
    /// - Parameter completion: provides a list of rooms. This returns on a background thread
    public func fetchRooms(completion: @escaping RoomCompletion) {
         super.get(route: "rooms", completion: completion)
    }
}

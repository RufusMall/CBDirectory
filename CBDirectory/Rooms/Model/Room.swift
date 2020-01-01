//
//  Room.swift
//  CBDirectory
//
//  Created by Rufus on 01/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation

public struct Room: Codable {
    public let id, createdAt, name: String
    public let isOccupied: Bool

    public init(id: String, createdAt: String, name: String, isOccupied: Bool) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.isOccupied = isOccupied
    }
}

//
//  PersonDetails.swift
//  CBDirectory
//
//  Created by Rufus on 01/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation

public struct PersonDetails: Decodable {
    public let id, createdAt: String
    public let avatar: String
    public let jobTitle, phone, favouriteColor, email: String
    public let firstName, lastName: String
    
    public init(id: String, createdAt: String, avatar: String, jobTitle: String, phone: String, favouriteColor: String, email: String, firstName: String, lastName: String) {
        self.id = id
        self.createdAt = createdAt
        self.avatar = avatar
        self.jobTitle = jobTitle
        self.phone = phone
        self.favouriteColor = favouriteColor
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}

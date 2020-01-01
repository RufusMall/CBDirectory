//
//  RoomCellViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 01/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation
import UIKit

public class RoomCellViewModel {
    public struct State {
        public let name: String
        public let availabilityStatusText: String
        public let availabilityStatusColor: UIColor
    }
    
    var state: State
    
    init(room: Room) {
        let name = room.name
        let availabilityStatusText = room.isOccupied ? "Occupied" : "Available"
        let color: UIColor = room.isOccupied ? .systemRed : .systemGreen
        
        self.state = State(name: name, availabilityStatusText: availabilityStatusText, availabilityStatusColor: color)
    }
}

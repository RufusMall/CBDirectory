//
//  RoomListViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 01/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation

public class RoomListViewModel {
    public struct State {
        public let title = "Rooms"
        public var errorMessage: String?
        public var rooms = [RoomCellViewModel]()
    }
    
    private let service: RoomServiceProtocol
    private let stateChanged: (State)->()
    
    public var state = State() {
        didSet {
            self.stateChanged(state)
        }
    }
    
    public init(service: RoomServiceProtocol, stateChanged:@escaping (State)->()) {
        self.stateChanged = stateChanged
        self.service = service
    }
    
    public func start() {
        self.stateChanged(state)
        fetchRooms()
    }
    
    public func refresh() {
        fetchRooms()
    }
    
    private func fetchRooms() {
        service.fetchRooms { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let rooms):
                    let roomCellViewModels = rooms.map { (room) -> RoomCellViewModel in
                        return RoomCellViewModel(room: room)
                    }
                    self.state = State(errorMessage: nil, rooms: roomCellViewModels)
                case .failure(let error):
                    //continue to show old rooms. Should really improve this so we show some sort of error + existing fetched room
                    self.state = State(errorMessage: error.localizedDescription, rooms: self.state.rooms)
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//
//  RoomListViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 01/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation
import Common

public struct RoomListViewState: CreateDefault {
    public static func `default`() -> RoomListViewState {
        return RoomListViewState()
    }
    
    public typealias ViewState = RoomListViewState
    
    public let title = "Rooms"
    public var errorMessage: String?
    public var rooms = [RoomCellViewModel]()
}

public class RoomListViewModel: ViewModel<RoomListViewState> {
    private let service: RoomServiceProtocol
    
    public init(service: RoomServiceProtocol, stateChanged:((RoomListViewState)->())? = nil) {
        self.service = service
        super.init(stateChanged: stateChanged)
    }
    
    public override func start() {
        super.start()
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
                    
                    let roomsOrderedByStatus = roomCellViewModels.sorted { (r1, r2) -> Bool in
                        return r1.state.availabilityStatusText < r2.state.availabilityStatusText
                    }
                    
                    self.state = RoomListViewState(errorMessage: nil, rooms: roomsOrderedByStatus)
                case .failure(let error):
                    //continue to show old rooms. Should really improve this so we show some sort of error + existing fetched room
                    self.state = RoomListViewState(errorMessage: error.localizedDescription, rooms: self.state.rooms)
                    print(error.localizedDescription)
                }
            }
        }
    }
}

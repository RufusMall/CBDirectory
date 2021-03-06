//
//  ViewController.swift
//  CBDirectory
//
//  Created by Rufus on 22/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import UIKit
import Common

public class RoomListViewController: UIViewController {
    var viewModel: RoomListViewModel!
    var roomService: RoomServiceProtocol!
    
    let refreshControl: UIRefreshControl = {
           let refreshControl = UIRefreshControl()
           return refreshControl
       }()
    
    fileprivate func handleErrorMessages(_ state: RoomListViewState) {
        if let errorMsg = state.errorMessage {
            let errorLabel = UILabel()
            errorLabel.text = errorMsg
            errorLabel.textAlignment = .center
            self.tableView.backgroundView = errorLabel
        } else {
            self.tableView.backgroundView = nil
        }
    }
    
    public init(roomService: RoomServiceProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "room", systemName: "studentdesk")
        self.roomService = roomService
        
        viewModel = RoomListViewModel(service: roomService, stateChanged: { [weak self] (state) in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.title = state.title
            
            self.handleErrorMessages(state)
            
            self.refreshControl.endRefreshing()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.allowsMultipleSelection = false
        tableView.register(RoomCell.self, forCellReuseIdentifier: RoomCell.cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let viewToHideCellSeperatorsWhenTableIsEmpty = UIView()
        tableView.tableFooterView = viewToHideCellSeperatorsWhenTableIsEmpty
        tableView.allowsSelection = false
        return tableView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.constrainPinningEdgesToSuperview()
        
        tableView.refreshControl = refreshControl
              tableView.rowHeight = UITableView.automaticDimension
              refreshControl.addTarget(self, action: #selector(self.refreshControlChanged), for: .valueChanged)
        
        viewModel.start()
    }
    
    @objc func refreshControlChanged(sender: Any?) {
          viewModel.refresh()
      }
}

extension RoomListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.rooms.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let roomVM = viewModel.state.rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: RoomCell.cellID, for: indexPath) as! RoomCell
        cell.viewModel = roomVM
        return cell
    }
}

import SwiftUI

class RoomListPreview: ViewControllerPreviewProvider<RoomListViewController>, PreviewProvider {
    
    override class func makeController() -> UIViewController {
        let roomListController = RoomListViewController(roomService: MockRoomService())
        let navController = UINavigationController(rootViewController: roomListController)
        return navController
    }
}

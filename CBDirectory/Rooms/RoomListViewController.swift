//
//  ViewController.swift
//  CBDirectory
//
//  Created by Rufus on 22/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import UIKit

class RoomListViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Rooms", systemName: "studentdesk")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI
class RoomListPreview: ViewControllerPreviewProvider<RoomListViewController>, PreviewProvider {
    override class func makeController() -> UIViewController {
        let navController = UINavigationController(rootViewController: super.makeController())
        return navController
    }
}

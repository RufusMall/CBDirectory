//
//  ViewController.swift
//  CBDirectory
//
//  Created by Rufus on 22/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import UIKit

class RoomListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rooms"
    }
}

import SwiftUI

class RoomListPreview: ViewControllerPreviewProvider<RoomListViewController>, PreviewProvider {
    override class func makeController() -> UIViewController {
        let tabBarController = UITabBarController()
        let navController = UINavigationController(rootViewController: super.makeController())
        tabBarController.setViewControllers([navController, PersonListViewController()], animated: false)
        return tabBarController
    }
}

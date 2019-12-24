//
//  ViewController.swift
//  CBDirectory
//
//  Created by Rufus on 22/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import UIKit

class PersonListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

import SwiftUI

class PersonListPreview: ViewControllerPreviewProvider<PersonListViewController>, PreviewProvider {
    override class func makeController() -> UIViewController {
        let tabBarController = UITabBarController()
        let navController = UINavigationController(rootViewController: super.makeController())
        tabBarController.setViewControllers([navController, RoomListViewController()], animated: false)
        return tabBarController
    }
}

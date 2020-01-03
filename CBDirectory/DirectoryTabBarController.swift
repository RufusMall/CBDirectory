//
//  DirectoryTabBarController.swift
//  CBDirectory
//
//  Created by Rufus on 26/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit
import Common
import People
import Rooms

class DirectoryTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let splitViewController = UISplitViewController()
        
        let env = Environment.dev.url
        let personService: PersonServiceProtocol = PersonService(baseURL: env)
        let roomService: RoomServiceProtocol = RoomService(baseURL: env)
        
        let personNavStack = UINavigationController(rootViewController: PersonListViewController(personService: personService))
        let roomNavStack = UINavigationController(rootViewController: RoomListViewController(roomService: roomService))
        
        splitViewController.tabBarItem = personNavStack.topViewController?.tabBarItem
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.viewControllers = [personNavStack]
        viewControllers = [splitViewController, roomNavStack]
    }
}

import SwiftUI
//define this class as a helper to creating a preview for the app. This implicitly implements "PreviewProvider" so we can explicitly add "PreviewProvider" in other files. For the canvas preview to display, "PreviewProvider" must be contained in that specific file
class DirectoryTabControllerPreview: ViewControllerPreviewProvider<DirectoryTabBarController> {
    
}

class MyDirectoryTabControllerPreview: DirectoryTabControllerPreview, PreviewProvider {
}

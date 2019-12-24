//
//  SceneDelegate.swift
//  CBDirectory
//
//  Created by Rufus on 22/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = (scene as? UIWindowScene) {
            let window = UIWindow(windowScene: windowScene)
            let tabBarController = UITabBarController()
            
            let personNavStack = UINavigationController(rootViewController: PersonListViewController())
            let roomNavStack = UINavigationController(rootViewController: RoomListViewController())
            tabBarController.viewControllers = [personNavStack, roomNavStack]
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
            self.window = window
        }
    }
}


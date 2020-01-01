//
//  AppDelegate.swift
//  CBDirectory
//
//  Created by Rufus on 22/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let tabBarController = DirectoryTabBarController()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let brandColor = UIColor(red: 196.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 255.0)
        let theme = DefaultTheme(window: window, themeColor: brandColor)
        theme.apply()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}


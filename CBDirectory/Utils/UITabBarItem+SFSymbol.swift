//
//  UIImage+TabBar.swift
//  CBDirectory
//
//  Created by Rufus on 25/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarItem {
    public convenience init?(title: String?, systemName: String) {
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin)
        let image = UIImage(systemName: systemName, withConfiguration: imgConfig)
//        let image = UIImage(named: systemName)
        self.init(title: title, image: image, selectedImage: nil)
    }
}

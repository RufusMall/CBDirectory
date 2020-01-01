//
//  DefaultTheme.swift
//  CBDirectory
//
//  Created by Rufus on 01/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation
import UIKit

public class DefaultTheme {
    let window: UIWindow
    let themeColor: UIColor
    
    public init(window: UIWindow, themeColor: UIColor) {
        self.window = window
        self.themeColor = themeColor
    }
    
    open func apply() {
        UIView.appearance().tintColor = themeColor
        window.tintColor = themeColor
        
        UIImageView.appearance().borderColor = themeColor
        
        let labelProxy = UILabel.appearance()
        labelProxy.font = UIFont.preferredFont(forTextStyle: .body)
        labelProxy.adjustsFontForContentSizeCategory = true
        labelProxy.numberOfLines = 0
        
        let textProxy = UITextView.appearance()
        textProxy.font = UIFont.preferredFont(forTextStyle: .body)
        textProxy.adjustsFontForContentSizeCategory = true
    }
}

extension UIView {
    @objc public var borderColor : UIColor? {
        set(color) { layer.borderColor = color?.cgColor }
        get { return layer.borderColor as? UIColor? ?? nil }
    }
}

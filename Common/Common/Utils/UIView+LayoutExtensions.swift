//
//  UIView+Extensions.swift
//  CBDirectory
//
//  Created by Rufus on 22/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public func constrainPinningEdgesToSuperview(constant: CGFloat = 0) {
        guard let superview = self.superview  else {
            fatalError("constrainPinningEdgesToSuperview requires a valid superview")
        }
        constrainPinningEdges(to: superview, constant: constant)
    }
    
    public func constrainPinningEdges(to view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:constant).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-constant).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant:constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-constant).isActive = true
    }
}

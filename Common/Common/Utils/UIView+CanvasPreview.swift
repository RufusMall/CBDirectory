//
//  UIView+CanvasPreview.swift
//  CBDirectory
//
//  Created by Rufus on 22/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import SwiftUI

public struct ViewControllerContainerView : UIViewControllerRepresentable {
    public typealias UIViewControllerType = UIViewController
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerContainerView>) -> UIViewControllerType {
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ViewControllerContainerView>) {
    }
}

open class ViewControllerPreviewProvider<T: UIViewController> {
   public static var previews: some View {
        return ViewControllerContainerView(viewController: makeController()).edgesIgnoringSafeArea(.all)
    }
    
    open class func makeController() -> UIViewController {
        return T()
    }
}

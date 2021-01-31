//
//  View+Ext.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 31/01/2021.
//

import Foundation
import SwiftUI

extension View {
    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}


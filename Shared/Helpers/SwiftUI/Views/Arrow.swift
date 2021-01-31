//
//  Arrow.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 26/01/2021.
//

import Foundation
import SwiftUI

// MARK: - Arrow Shape
// https://www.ioscreator.com/tutorials/swiftui-custom-shape-tutorial

struct Arrow: Shape {

    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            path.addLines( [
                CGPoint(x: width * 0.4, y: height),
                CGPoint(x: width * 0.4, y: height * 0.4),
                CGPoint(x: width * 0.2, y: height * 0.4),
                CGPoint(x: width * 0.5, y: height * 0.1),
                CGPoint(x: width * 0.8, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height)
            ])
            
            path.closeSubpath()
        }
    }
}

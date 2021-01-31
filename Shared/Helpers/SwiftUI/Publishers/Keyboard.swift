//
//  Keyboard.swift
//  Envision-Highlighter-AssignmentTests
//
//  Created by Hoye Lam on 28/01/2021.
//

import Foundation
import SwiftUI
import Combine

// Learn more: https://www.vadimbulavin.com/how-to-move-swiftui-view-when-keyboard-covers-text-field/

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
   
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

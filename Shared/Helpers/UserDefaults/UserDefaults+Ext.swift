//
//  UserDefaults+Ext.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 28/01/2021.
//

import Foundation
import SwiftUI

// Learn mmore: https://www.avanderlee.com/swift/property-wrappers/

extension UserDefaults {
    @UserDefault(key: "completed_onboarding", defaultValue: false)
    static var completedOnboarding: Bool
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}


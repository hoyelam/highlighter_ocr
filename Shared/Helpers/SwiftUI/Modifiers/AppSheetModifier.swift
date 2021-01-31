//
//  AppSheetModifier.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 29/01/2021.
//

import Foundation
import SwiftUI

/// Applies the default sheet design style 
struct AppSheetModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .padding(.vertical)
            .background(Color.secondaryBackground)
            .edgesIgnoringSafeArea(.all)
        
        
    }
}

extension View {
    func appSheetStyleModifier() -> some View {
        self.modifier(AppSheetModifier())
    }
}

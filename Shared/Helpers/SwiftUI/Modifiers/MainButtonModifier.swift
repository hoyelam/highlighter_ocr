//
//  MainButtonModifier.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 26/01/2021.
//

import SwiftUI

/// Applies main button style of the mobile app
struct MainButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.text)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accent)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}

extension View {
    func mainButtonModifier() -> some View {
        self.modifier(MainButtonModifier())
    }
}

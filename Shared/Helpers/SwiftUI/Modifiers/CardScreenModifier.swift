//
//  CardScreenModifier.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 28/01/2021.
//

import Foundation
import SwiftUI

/// Applies the default app card full screen area view
struct CardScreenModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            content
                .padding()
                .background(Color.secondaryBackground)
                .cornerRadius(16)
        }
        .padding()
        .padding(.top, 56)
        .padding(.bottom, 56)
        .frame(maxWidth: .infinity)
        .background(Color.background)
        .edgesIgnoringSafeArea(.all)
        
            
    }
}

extension View {
    func cardScreenModifier() -> some View {
        self.modifier(CardScreenModifier())
    }
}

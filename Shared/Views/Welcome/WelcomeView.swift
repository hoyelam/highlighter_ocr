//
//  WelcomeView.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 26/01/2021.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("welcome_screen_title")
                .font(.title)
                .foregroundColor(.text)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .center, spacing: 0) {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: 16)
                
                Triangle()
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: 180))
                    .frame(width: 32, height: 32)
            }
            .padding([.vertical])
            .frame(minHeight: 360)
            .accessibility(label: Text("welcome_arrow_accessibility_label"))
            
            Spacer()
        }
        .background(Color.background)
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}


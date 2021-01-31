//
//  HighlightRowView.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 28/01/2021.
//

import SwiftUI

struct HighlightRowView: View {
    var highlight: Highlight
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(highlight.text)
                .font(.body)
                .foregroundColor(.text)
            
            Divider()
                .background(Color.white)
                
        }
        .background(Color.secondaryBackground)
    }
}

struct HighlightRowView_Previews: PreviewProvider {
    static var previews: some View {
        HighlightRowView(highlight: .newRandom(bookId: 0))
    }
}

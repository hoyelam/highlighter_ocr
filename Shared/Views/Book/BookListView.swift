//
//  BookListView.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 29/01/2021.
//

import SwiftUI

struct BookListView: View {
    @Binding var showBookHighlightsSheet: Bool
    @Binding var bookListItems: [BookListItem]
    @Binding var selectedBook: Book?
    
    var body: some View {
        VStack {
            Text("Books")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.text)
            
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem()], spacing: 16) {
                    ForEach(bookListItems, id: \.self) { item in
                        NavigationLink(destination: BookHighlightsView(book: item.book,
                                                                       sheetBind: .constant(false))) {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(item.book.title)")
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.text)
                                        
                                        Text("\(item.highlightCount) highlights")
                                            .font(.caption)
                                            .foregroundColor(.secondaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.forward")
                                        .font(.title3)
                                        .foregroundColor(Color.text)
                                }
                                .padding()
                                
                                Divider()
                                    .background(Color.white)
                            }
                        }
                        .accessibility(label: Text("press_to_see_highlight_accessibility_label \(item.book.title)"))
                    }
                }
                .padding(.top)
                .background(Color.secondaryBackground)
            }
        }
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockData: [BookListItem] = [.init(book: .newRandom(), highlightCount: Int.random(in: 10...20))]
        
        return BookListView(showBookHighlightsSheet: .constant(false),
                            bookListItems: .constant(mockData),
                            selectedBook: .constant(.none))
    }
}

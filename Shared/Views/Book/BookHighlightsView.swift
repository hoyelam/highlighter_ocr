//
//  AddHighlightView.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 28/01/2021.
//

import SwiftUI

struct BookHighlightsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: BookHighlightsViewModel
    
    init(book: Book, database: AppDatabase = AppDatabase.shared) {
        let viewModel = BookHighlightsViewModel(book: book, database: database)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    init(viewModel: BookHighlightsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Text("\(viewModel.book.title)")
                    .font(.title)
                    .foregroundColor(.text)
            }
            
            Divider()
                .background(Color.white)
            
            ScrollView {
                LazyVGrid(columns: [GridItem()], spacing: 16) {
                    ForEach(viewModel.highlights) { highlight in
                        HighlightRowView(highlight: highlight)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                
            }) {
                Text("add_highlight_button_text")
                    .font(.title)
                    .foregroundColor(.text)
            }
            .mainButtonModifier()
        }
        .cardScreenModifier()
        .navigationBarHidden(true)
    }
}

struct BookHighlightsView_Previews: PreviewProvider {
    static var previews: some View {
        let book = Book(id: 0, title: "Envision Road")
        BookHighlightsView(viewModel:
                            BookHighlightsViewModel(book: book,
                                                    highlights: [.newRandom(bookId: book.id!),
                                                                 .newRandom(bookId: book.id!),
                                                                 .newRandom(bookId: book.id!),
                                                                 .newRandom(bookId: book.id!),
                                                                 .newRandom(bookId: book.id!),
                                                                 .newRandom(bookId: book.id!),], database: try! AppDatabase.random()))
    }
}

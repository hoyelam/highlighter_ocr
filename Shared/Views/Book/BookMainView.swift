//
//  BookMainView.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 29/01/2021.
//

import SwiftUI

struct BookMainView: View {
    @StateObject var viewModel = BookMainViewModel(database: AppDatabase.shared)
    
    @State private var showAddBookSheet: Bool = false
    @State private var showBookDetailSheet: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.bookListItems.count == 0 {
                    ScrollView(.vertical) {
                        WelcomeView()
                    }
                } else {
                    BookListView(showBookHighlightsSheet: $showBookDetailSheet,
                                 bookListItems: $viewModel.bookListItems,
                                 selectedBook: $viewModel.selectedBook)
                        .sheet(isPresented: $showBookDetailSheet) {
                            BookHighlightsView(book: viewModel.selectedBook!,
                                               sheetBind: $showBookDetailSheet)
                        }
                }
                
                Spacer()
                
                Button(action: {
                    showAddBookSheet.toggle()
                }) {
                    Text(viewModel.bookListItems.count == 0 ? "welcome_screen_button_text" : "add_book_button_text")
                        .font(.title)
                        .foregroundColor(.text)
                }
                .mainButtonModifier()
                .padding(.horizontal)
                .sheet(isPresented: $showAddBookSheet) {
                    EnterBookNameView(sheet: $showAddBookSheet)
                }
            }
            .padding(.vertical, 56)
            .background(Color.background)
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct BookMainView_Previews: PreviewProvider {
    static var previews: some View {
        BookMainView(viewModel: BookMainViewModel(database: try! .random()))
    }
}

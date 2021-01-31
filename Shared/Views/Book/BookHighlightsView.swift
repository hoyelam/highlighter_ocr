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
    @Binding var sheetBind: Bool
    
    @State private var showScanHighlighCamera: Bool = false
    
    init(book: Book, database: AppDatabase = AppDatabase.shared, sheetBind: Binding<Bool>) {
        let viewModel = BookHighlightsViewModel(book: book, database: database)
        _viewModel = StateObject(wrappedValue: viewModel)
        _sheetBind = sheetBind
    }
    
    init(viewModel: BookHighlightsViewModel, sheetBind: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _sheetBind = sheetBind
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    self.presentationMode.dismiss()
                    self.sheetBind.toggle()
                }) {
                    Text("Back")
                        .font(.body)
                        .foregroundColor(.text)
                        .padding(8)
                        .background(Color.textFieldBackground)
                        .cornerRadius(16)
                }
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                Text("\(viewModel.book.title)")
                    .font(.title)
                    .foregroundColor(.text)
            }
            
            Divider()
                .background(Color.white)
            
            ScrollView(.vertical) {
                if viewModel.highlights.count > 0 {
                    LazyVGrid(columns: [GridItem()], spacing: 16) {
                        ForEach(viewModel.highlights) { highlight in
                            HighlightRowView(highlight: highlight)
                        }
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text("no_highlights_message")
                            .font(.title3)
                            .foregroundColor(.text)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                self.showScanHighlighCamera.toggle()
            }) {
                Text("add_highlight_button_text")
                    .font(.title)
                    .foregroundColor(.text)
            }
            .mainButtonModifier()

            .sheet(isPresented: $showScanHighlighCamera, content: {
                CameraHighlightView() { highlightText in
                    guard !highlightText.isEmpty else { return }
                    self.viewModel.storeHighlight(text: highlightText)
                    self.sheetBind.toggle()
                }
            })
        }
        .padding(.vertical)
        .appSheetStyleModifier()
        .navigationBarHidden(true)
        .onAppear(perform: viewModel.checkIfBookExistsInDb)
    }
}

struct BookHighlightsView_Previews: PreviewProvider {
    static var previews: some View {
        let book = Book(id: 0, title: "Envision Road")
        BookHighlightsView(viewModel:
                            BookHighlightsViewModel(book: book,
                                                    highlights: [],
                                                    database: try! AppDatabase.random()),
                           sheetBind: .constant(true))
    }
}

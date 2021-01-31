//
//  EnterBookNameView.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 29/01/2021.
//

import SwiftUI
import SwiftUIX

struct EnterBookNameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var bookTitle: String = ""
    @State private var showNoTitleGivenAlert: Bool = false
    @Binding var sheet: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 16) {
                    headerView
                    
                    textFieldView
                    
                    Spacer()
                    
                    if bookTitle.isEmpty {
                        addBookAlertButtonView
                    } else {
                        addBookButtonNavigationView
                    }
                }
            }
            .padding()
            .padding(.vertical)
            .background(Color.secondaryBackground)
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack(spacing: 16) {
            Text("add_book_view_title")
                .font(.title)
                .foregroundColor(.text)
            
            Spacer()
            
            Button(action: {
                self.presentationMode.dismiss()
            }, label: {
                Text("close_button_text")
                    .font(.body)
                    .foregroundColor(.text)
            })
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.secondAccent)
            .cornerRadius(16)
            .accessibility(label: Text("return_last_view_label"))
        }
    }
    
    private var textFieldView: some View {
        ZStack(alignment: .leading) {
            if bookTitle.isEmpty {
                Text("enter_book_name_placeholder_textfield")
                    .foregroundColor(.secondaryText)
            }
            
            CocoaTextField("", text: $bookTitle)
                .foregroundColor(.white)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color.textFieldBackground)
        .cornerRadius(8)
    }
    
    private var addBookAlertButtonView: some View {
        Button(action: {
            guard !bookTitle.isEmpty else {
                self.showNoTitleGivenAlert.toggle()
                return
            }
        }) {
            Text("add_book_button_text")
                .font(.title)
                .foregroundColor(.text)
        }
        .mainButtonModifier()
        .keyboardAdaptive()
        .alert(isPresented: self.$showNoTitleGivenAlert) {
            Alert(title: Text("no_title_given_alert_title"),
                  message: Text("no_title_given_alert_message"),
                  dismissButton: .default(Text("okay")))
        }
    }
    
    private var addBookButtonNavigationView: some View {
        // BookHighlightView will automatically store the book
        NavigationLink(destination: BookHighlightsView(book: .init(id: nil,
                                                                   title: bookTitle),
                                                       sheetBind: $sheet)) {
            Text("add_book_button_text")
                .font(.title)
                .foregroundColor(.text)
        }
        .mainButtonModifier()
        .keyboardAdaptive()
    }
}

struct EnterBookNameView_Previews: PreviewProvider {
    static var previews: some View {
        EnterBookNameView(sheet: .constant(true))
    }
}

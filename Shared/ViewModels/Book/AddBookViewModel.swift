//
//  AddBookViewModel.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 28/01/2021.
//

import Foundation
import SwiftUI
import Combine

class AddBookViewModel: ObservableObject {
    @Published var newBook = Book(id: nil, title: "")
    
    private let bookManager: DatabaseManager
    
    init(database: AppDatabase = AppDatabase.shared) {
        bookManager = DatabaseManager(database: database)
    }
    
    func saveNewBook() {
        do {
            try bookManager.saveBook(&newBook)
        } catch let error {
            AppOSLog.logError(class: AddBookViewModel.self, error: error)
        }
    }
}

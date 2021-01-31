//
//  BookHighlightsView.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 28/01/2021.
//

import Foundation
import Combine
import SwiftUI

final class BookHighlightsViewModel: ObservableObject {
    @Published var book: Book
    @Published var highlights: [Highlight] = []
    
    private let manager: DatabaseManager
    
    private var pubCancellable: AnyCancellable? = nil
    
    init(book: Book, database: AppDatabase = AppDatabase.shared) {
        self.book = book
        self.manager = DatabaseManager(database: database)
        
        self.subscribeToHighlights()
    }
    
    /// For SwiftUI Preview
    init(book: Book, highlights: [Highlight], database: AppDatabase) {
        self.book = book
        self.highlights = highlights
        self.manager = DatabaseManager(database: database)
    }
    
    private func subscribeToHighlights() {
        guard let bookId = book.id else { return }
        
        self.pubCancellable = manager
            .highlightsPublisher(bookId: bookId)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (highlights) in
                self?.highlights = highlights
            }
    }
    
    /// Handles cases where the book has no ID
    func checkIfBookExistsInDb() {
        do {
            if book.id == nil {
                try self.manager.saveBook(&book)
            }
        } catch let error {
            AppOSLog.logError(class: BookHighlightsViewModel.self, error: error)
        }
    }
    
    func storeHighlight(text: String) {
        guard let bookId = book.id else { return }
        var newHighlight = Highlight(id: nil, bookId: bookId, text: text)
        do {
            try? self.manager.saveHighlight(&newHighlight)
        }
    }
}

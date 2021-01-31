//
//  BookMainViewModel.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 29/01/2021.
//

import Foundation
import Combine
import GRDB

final class BookMainViewModel: ObservableObject {
    @Published var bookListItems: [BookListItem] = []
    @Published var selectedBook: Book? = nil
    
    private var databaseManager: DatabaseManager
    private var itemCancellable: AnyCancellable? = nil
    
    init(database: AppDatabase = .shared) {
        self.databaseManager = DatabaseManager(database: database)
        
        self.subscribeToDatabasePublishers()
    }
}

extension BookMainViewModel {
    // Subscribes to database changes of books
    private func subscribeToDatabasePublishers() {
        let cancellable = self
            .databaseManager
            .booksListPublisher()
            .eraseToAnyPublisher()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (bookListItems) in
                self?.bookListItems = bookListItems
            }
        
        self.itemCancellable = cancellable
    }
    

}

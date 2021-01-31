//
//  BooksManager.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 28/01/2021.
//

import Foundation
import Combine
import GRDB

class DatabaseManager {    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
}

// Feeds the list of books
extension DatabaseManager {
    /**
     Return an array of books ordered by name
     - Returns: An array of `Book`.
     */
    func bookList() throws -> [Book] {
        try database.dbWriter.read { db in
            let request = Book
                .all()
                .orderedByName()
                
            return try Book.fetchAll(db, request)
        }
    }
    
    /**
     Fetches an array of highlights based on a bookId
     - Parameter bookId: Book id
     - Returns: An array of `Highlight`.
     */
    func highlistList(bookId: Int64) throws -> [Highlight] {
        try database.dbWriter.read { db in
            let request = Highlight
                .filter(Column("bookId") == bookId)
            
            return try Highlight.fetchAll(db, request)
        }
    }
    
    
    /// Returns a publisher that tracks changes in books ordered by name
    func booksPublisher() -> AnyPublisher<[Book], Error> {
        ValueObservation
            .tracking(Book.all().orderedByName().fetchAll)
            .publisher(in: database.dbWriter, scheduling: .immediate)
            .eraseToAnyPublisher()
    }
    
    /// Returns a publisher that tracks changes in highlights
    func highlightsPublisher(bookId: Int64) -> AnyPublisher<[Highlight], Error> {
        ValueObservation
            .tracking(Highlight.all().filter(Column("bookId") == bookId).fetchAll)
            .publisher(in: database.dbWriter, scheduling: .immediate)
            .eraseToAnyPublisher()
    }
}

// MARK: - Save Books and Highlights

extension DatabaseManager {
    func saveBook(_ book: inout Book) throws {
        try database.dbWriter.write { db in
            try book.save(db)
        }
    }
    
    func saveHighlight(_ highlight: inout Highlight) throws {
        try database.dbWriter.write { db in
            try highlight.save(db)
        }
    }
}

// MARK: - Delete Books and Highlights

extension DatabaseManager {
    func deleteBook(_ book: Book) throws {
        try database.dbWriter.write { db in
            _  = try book.delete(db)
        }
    }
    
    func deleteHighlight(_ highlight: Highlight) throws {
        try database.dbWriter.write { db in
            _ = try highlight.delete(db)
        }
    }
}

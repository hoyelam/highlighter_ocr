//
//  BookManagerTests.swift
//  Envision-Highlighter-AssignmentTests
//
//  Created by Hoye Lam on 28/01/2021.
//

import XCTest
import GRDB
@testable import Envision_Highlighter_Assignment

class BookManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_saveBook_inserts() throws {
        // Given an empty books database
        let dbQueue = DatabaseQueue()
        let appDatabase = try AppDatabase(dbQueue)
        let manager = DatabaseManager(database: appDatabase)
        
        var book = Book.new()
        try manager.saveBook(&book)
        
        // Then the book should exist in the database
        try XCTAssertTrue(dbQueue.read(book.exists))
    }

    func test_saveBook_updates() throws {
        // Given an empty books database
        let dbQueue = DatabaseQueue()
        let appDatabase = try AppDatabase(dbQueue)
        let manager = DatabaseManager(database: appDatabase)
        // When we save a new book
        
        var book = Book.new()
        
        // first insert
        try manager.saveBook(&book)
        
        book.title = "The pragmatic Programmer"
        // update
        try manager.saveBook(&book)
        
        // Then the book should have been updated
        let fetchedBook = try dbQueue.read { db in
            try XCTUnwrap(Book.fetchOne(db, key: book.id))
        }
        
        XCTAssertEqual(fetchedBook, book)
    }
    
    func test_saveHighlight_inserts() throws {
        // Given a book exists
        let dbQueue = DatabaseQueue()
        let appDatabase = try AppDatabase(dbQueue)
        let manager = DatabaseManager(database: appDatabase)
        
        var book = Book.new()
        try manager.saveBook(&book)
        
        // When saving highlight
        var highlight = Highlight(id: nil, bookId: book.id!, text: "Be simple")
        try manager.saveHighlight(&highlight)
        
        // Then highlight should exist in the database
        try XCTAssertTrue(dbQueue.read(highlight.exists))
    }
    
    
    func test_deleteBookAndHighlights() throws {
        // Given a book with highlights exists
        let dbQueue = DatabaseQueue()
        let appDatabase = try AppDatabase(dbQueue)
        let manager = DatabaseManager(database: appDatabase)
        
        var book = Book.new()
        try manager.saveBook(&book)
        
        var highlight1 = Highlight(id: nil, bookId: book.id!, text: "Be simple")
        var highlight2 = Highlight(id: nil, bookId: book.id!, text: "Do not repeat")
        try manager.saveHighlight(&highlight1)
        try manager.saveHighlight(&highlight2)
        
        // When
        try manager.deleteBook(book)
        
        // Then
        try XCTAssertEqual(dbQueue.read(Book.fetchCount), 0)
        try XCTAssertEqual(dbQueue.read(Highlight.fetchCount), 0)
    }
    
    // MARK: - Request
    // Test that request defined on the Book type behave as expected
    
    func test_fetch_books_orderByName() throws {
        // Given
        let dbQueue = DatabaseQueue()
        let database = try AppDatabase(dbQueue)
        let manager = DatabaseManager(database: database)
        
        var book1 = Book(id: nil, title: "Atomic Habits")
        var book2 = Book(id: nil, title: "Breath")
        var book3 = Book(id: nil, title: "Remote")
        
        try manager.saveBook(&book3)
        try manager.saveBook(&book2)
        try manager.saveBook(&book1)
        
        // When we fetch
        let books = try manager.bookList()
        
        // Then
        XCTAssertEqual(books, [book1, book2, book3])
    }

    func test_fetch_highlights() throws {
        // Given
        let dbQueue = DatabaseQueue()
        let database = try AppDatabase(dbQueue)
        let manager = DatabaseManager(database: database)
        var book = Book.newRandom()
        try manager.saveBook(&book)
        
        var highlight1 = Highlight(id: nil, bookId: book.id!, text: "Be simple")
        var highlight2 = Highlight(id: nil, bookId: book.id!, text: "Turn it off")
        var highlight3 = Highlight(id: nil, bookId: book.id!, text: "By god")
        
        try manager.saveHighlight(&highlight1)
        try manager.saveHighlight(&highlight2)
        try manager.saveHighlight(&highlight3)
        
        // When
        let highlights = try manager.highlistList(bookId: book.id!)
        
        // Then
        XCTAssertEqual(highlights, [highlight1, highlight2, highlight3])
    }
}

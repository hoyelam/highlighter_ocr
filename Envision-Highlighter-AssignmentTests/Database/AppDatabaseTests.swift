//
//  AppDatabaseTests.swift
//  Envision-Highlighter-AssignmentTests
//
//  Created by Hoye Lam on 28/01/2021.
//

import XCTest
import GRDB
@testable import Envision_Highlighter_Assignment

class AppDatabaseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_database_schema() throws {
        // Given
        let dbQueue = DatabaseQueue()
        
        // When
        _ = try AppDatabase(dbQueue)
        
        // Then
        try dbQueue.read { db in
            try XCTAssert(db.tableExists("book"))
            try XCTAssert(db.tableExists("highlight"))
            
            // Book
            let bookColumns = try db.columns(in: "book")
            let bookColumnNames = Set(bookColumns.map {$0.name} )
            
            XCTAssertEqual(bookColumnNames, ["id", "title"])
            
            // Highlight
            let highlightColumns = try db.columns(in: "highlight")
            let highlightColumnsNames = Set(highlightColumns.map {$0.name })
            
            XCTAssertEqual(highlightColumnsNames, ["bookId", "id", "text"])
        }
    }
    
    func test_random_database() throws {
        // When
        let database = try AppDatabase.random()
        
        // Then
        try database.dbWriter.read { db in
            let fetchedBooks = try Book.fetchAll(db)
            let fetchedHighlights = try Highlight.fetchAll(db)
            
            XCTAssertNotEqual(fetchedBooks.count, 0)
            XCTAssertNotEqual(fetchedHighlights.count, 0)
        }
    }

}

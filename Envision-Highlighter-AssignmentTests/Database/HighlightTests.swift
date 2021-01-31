//
//  HighlightTests.swift
//  Envision-Highlighter-AssignmentTests
//
//  Created by Hoye Lam on 28/01/2021.
//

import XCTest
import GRDB
@testable import Envision_Highlighter_Assignment

class HighlightTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_insert() throws {
        // Given
        let database = AppDatabase.empty()
        let manager = DatabaseManager(database: database)
        var book = Book.newRandom()
        try manager.saveBook(&book)
        
        // When
        var highlight = Highlight(id: nil, bookId: book.id!, text: "Buy high sell higher")
        try manager.saveHighlight(&highlight)
        
        // Then
        XCTAssertNotNil(highlight.id)
    }
}

//
//  AddBookViewModelTests.swift
//  Envision-Highlighter-AssignmentTests
//
//  Created by Hoye Lam on 28/01/2021.
//

import XCTest
import GRDB
@testable import Envision_Highlighter_Assignment

class AddBookViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_saveBook() throws {
        // Given
        let dbQueue = DatabaseQueue()
        let appDatabase = try AppDatabase(dbQueue)
        let viewModel = AddBookViewModel(database: appDatabase)
        let expectedName = "Ain't no mountain high enough"
        viewModel.newBook.title = expectedName
        
        // When
        viewModel.saveNewBook()
        
        // Then
        try dbQueue.read { db in
            let books = try Book.fetchAll(db)
            guard let fetchedBook = books.first else {
                XCTFail("Book not stored correctly: \(String(describing: self))")
                return
            }
            
            XCTAssertEqual(fetchedBook.title, viewModel.newBook.title)
        }
    }
}

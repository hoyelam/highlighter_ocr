//
//  Book.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 28/01/2021.
//

import GRDB

struct Book: Hashable {
    /// Int64 is the recommended type for auto-incremented database ids
    var id: Int64?
    var title: String
}

extension Book {
    static let highlights = hasMany(Highlight.self)
}

extension Book {
    private static let mockTitles = ["Envision Road",
                                     "Atomic Habits",
                                     "Hacking Growth",
                                     "Thing Explainer",
                                     "Remote",
                                     "The Lessons of History",
                                     "Breath",
                                     "This is Marketing"]
    
    /// Creates a new book with empty name and zero score
    static func new() -> Book {
        Book(id: nil, title: "")
    }
    
    /// Creates a new book with random name and random score
    static func newRandom() -> Book {
        Book(id: nil, title: randomTitle())
    }
    
    /// Returns a random name
    static func randomTitle() -> String {
        mockTitles.randomElement()!
    }
}


// MARK: - Persistence
/// Make Book a Codable Record.
///
/// See https://github.com/groue/GRDB.swift/blob/master/README.md#records
extension Book: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let title = Column(CodingKeys.title)
    }
    
    /// Updates a book id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

// MARK: - Book Database Requests
/// Define some book requests used by the application.
///
/// See https://github.com/groue/GRDB.swift/blob/master/README.md#requests
/// See https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md
extension DerivableRequest where RowDecoder == Book {
    /// A request of Books ordered by title
    func orderedByName() -> Self {
        order(Book.Columns.title)
    }
}

extension Book: Equatable {}

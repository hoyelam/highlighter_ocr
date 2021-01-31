//
//  Persistence.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 28/01/2021.
//

import Foundation
import GRDB

extension AppDatabase {
    /// The database for the application
    static let shared = makeShared()
    
    private static func makeShared() -> AppDatabase {
        do {
            // Connect to a database on disk
            // See https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections
            let url: URL = try FileManager.default
                    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("db.sqlite")
            
            let dbQueue = try DatabaseQueue(path: url.path)
            let appDatabase = try AppDatabase(dbQueue)
            
            #if DEBUG
//            try appDatabase.dbWriter.write { db in
//                _ = try Book.deleteAll(db)
//            }
            #endif
            
            return appDatabase
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            //
            // Typical reasons for an error here include:
            // * The parent directory cannot be created, or disallows writing.
            // * The database is not accessible, due to permissions or data protection when the device is locked.
            // * The device is out of space.
            // * The database could not be migrated to its latest schema version.
            // Check the error message to determine what the actual problem was.
            fatalError("Unresolved error \(error)")
        }
    }
    
    /// Creates an empty database for SwiftUI previews
    static func empty() -> AppDatabase {
        // Connect to an in-memory database
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections
        let dbQueue = DatabaseQueue()
        return try! AppDatabase(dbQueue)
    }
    
    /// Creates a database full of random books for SwiftUI previews
    static func random() throws -> AppDatabase {
        let appDatabase = empty()
        
        try appDatabase.dbWriter.write { db in
            for _ in 0..<5 {
                // insert books
                var book = Book.newRandom()
                try book.save(db)
                
                for _ in 0..<5 {
                    // insert quote
                    var highlight = Highlight.newRandom(bookId: book.id!)
                    try highlight.save(db)
                }
            }
        }
        
        return appDatabase
    }
}

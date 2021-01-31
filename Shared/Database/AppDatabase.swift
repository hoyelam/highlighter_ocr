//
//  AppDatabase.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 26/01/2021.
//

import Combine
import GRDB

/// AppDatabase lets the application access the database.
///
/// It applies the pratices recommended at
/// https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md
struct AppDatabase {
    init(_ dbWriter: DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try migrator.migrate(dbWriter)
    }
    
    let dbWriter: DatabaseWriter

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("v1") { db in
            try db.create(table: "book") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
            }
            
            try db.create(table: "highlight") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("bookId", .integer).references("book",
                                                        column: "id",
                                                        onDelete: .cascade)
                t.column("text", .text).notNull()
            }
        }
        
        return migrator
    }
}

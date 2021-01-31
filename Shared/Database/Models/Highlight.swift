//
//  Highlight.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 28/01/2021.
//

import Foundation
import GRDB

struct Highlight: Identifiable, Codable {
    var id: Int64?
    var bookId: Int64
    var text: String
}

extension Highlight {
    static let book = belongsTo(Book.self)
}

extension Highlight {
    static let mockHighlights: [String] = [
        "I'm selfish, impatient and a little insecure. I make mistakes, I am out of control and at times hard to handle. But if you can't handle me at my worst, then you sure as hell don't deserve me at my best.",
        "Be yourself; everyone else is already taken",
        "Two things are infinite: the universe and human stupidity; and I'm not sure about the universe",
        "A room without books is like a body without a soul."
    ]
    
    /// Creates a new highlight with a bookId
    static func newRandom(bookId: Int64) -> Highlight {
        Highlight(id: Int64.random(in: 0...100000), bookId: bookId, text: randomHighlightText())
    }
    
    /// Returns a random name
    static func randomHighlightText() -> String {
        mockHighlights.randomElement()!
    }
}

extension Highlight: FetchableRecord, MutablePersistableRecord {
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension Highlight: Equatable { }

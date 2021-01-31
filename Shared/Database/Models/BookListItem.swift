//
//  BookListItem.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 31/01/2021.
//

import Foundation
import GRDB

struct BookListItem: Hashable, Decodable, FetchableRecord {
    let book: Book
    let highlightCount: Int
}

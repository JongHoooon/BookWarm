//
//  Book.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/08.
//

import Foundation

import RealmSwift

struct Book {
    let isbn: String
    let title: String
    let thumbnail: String
    private let _releaseDate: String
    var releaseDate: String {
        return _releaseDate
            .prefix(10)
            .split(separator: "-")
            .suffix(2)
            .joined(separator: ".")
    }
    
    init(
        isbn: String,
        title: String,
        thumbnail: String,
        releaseDate: String
    ) {
        self.isbn = isbn
        self.title = title
        self.thumbnail = thumbnail
        self._releaseDate = releaseDate
    }
}

class BookTable: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var title: String
    @Persisted var releaseDate: String
    @Persisted var thumbnail: String
    @Persisted var searchedDate: Date
    
    convenience init(
        id: String,
        title: String,
        releaseDate: String,
        thumbnail: String
    ) {
        self.init()
        self._id = id
        self.title = title
        self.releaseDate = releaseDate
        self.thumbnail = thumbnail
        self.searchedDate = Date()
    }
    
    func toBook() -> Book {
        return Book(
            isbn: _id,
            title: title,
            thumbnail: thumbnail,
            releaseDate: releaseDate
        )
    }
}

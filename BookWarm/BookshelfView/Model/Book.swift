//
//  Book.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/08.
//

import RealmSwift

struct Book {
    let title: String
    let releaseDate: String
    let thumbnail: String
}

class BookTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var releaseDate: String
    @Persisted var thumbnail: String
    
    convenience init(
        title: String,
        releaseDate: String,
        thumbnail: String
    ) {
        self.init()
        self.title = title
        self.releaseDate = releaseDate
        self.thumbnail = thumbnail
    }
}

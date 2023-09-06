//
//  BookTableRepository.swift
//  BookWarm
//
//  Created by JongHoon on 2023/09/06.
//

import Foundation
import RealmSwift

protocol BookTableRepository {
    func fetchBooks() async -> [Book]
    func deleteBook(primaryKey: String) async throws
    func editBookInfo(primaryKey: String, memo: String) async throws
}

final class DefaultBookTableRepository: BookTableRepository {
    private var realm: Realm = try! Realm()
    private let realmTaskQueue: DispatchQueue
    
    init?() {
        realmTaskQueue = DispatchQueue(label: "realm-serial-queue")
        do {
            try realmTaskQueue.sync {
                realm = try Realm(queue: realmTaskQueue)
            }
            if let url = realm.configuration.fileURL {
                print("📁📁📁 \(String(describing: url)) 📁📁📁")
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    func fetchBooks() async -> [Book] {
        await withCheckedContinuation { continuation in
            realmTaskQueue.async { [weak self] in
                guard let self else { return }
                
                let books: [Book] = self.realm
                    .objects(BookTable.self)
                    .sorted(
                        byKeyPath: "searchedDate",
                        ascending: false
                    )
                    .map { $0.toBook() }
                
                continuation.resume(returning: books)
            }
        }
    }
    
    func deleteBook(primaryKey: String) async throws {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }
            realmTaskQueue.async {
                guard let bookObject = self.realm.object(
                    ofType: BookTable.self,
                    forPrimaryKey: primaryKey
                ) else { return }
                
                do {
                    try self.realm.write {
                        self.realm.delete(bookObject)
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func editBookInfo(
        primaryKey: String,
        memo: String
    ) async throws {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }
            realmTaskQueue.async {
                guard let bookObject = self.realm.object(
                    ofType: BookTable.self,
                    forPrimaryKey: primaryKey
                ) else { return }

                do {
                    try self.realm.write {
                        bookObject.bookMemo = memo
                        self.realm.add(
                            bookObject,
                            update: .modified
                        )
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


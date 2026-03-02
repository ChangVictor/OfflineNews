//
//  ArticleLocalDataSource.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation
@preconcurrency import RealmSwift
internal import Realm

protocol ArticleLocalDataSource {
    func observeArticles() -> AsyncThrowingStream<[Article], Error>
    func observeArticle(id: Int) -> AsyncThrowingStream<Article?, Error>
    func upsert(articles: [Article]) throws
    func upsert(article: Article) throws
}

private final class NotificationTokenBox: @unchecked Sendable {
    var token: NotificationToken?
}

final class RealmArticleLocalDataSource: ArticleLocalDataSource {
    private let realmProvider: RealmProviding
    private let mapper: ArticleDataMapper
    
    init(realmProvider: RealmProviding, mapper: ArticleDataMapper) {
        self.realmProvider = realmProvider
        self.mapper = mapper
    }
    
    func observeArticles() -> AsyncThrowingStream<[Article], any Error> {
        AsyncThrowingStream { continuation in
            do {
                let realm = try realmProvider.makeRealm()
                let results = realm.objects(RealmArticleObject.self).sorted(byKeyPath: "publishedAt", ascending: false)
                
                let tokenBox = NotificationTokenBox()
                tokenBox.token = results.observe { [mapper] change in
                    switch change {
                    case let .initial(collection):
                        continuation.yield(collection.map(mapper.realmToDomain))
                    case let .update(collection, _, _, _):
                        continuation.yield(collection.map(mapper.realmToDomain))
                    case let .error(error):
                        continuation.finish(throwing: error)
                    }
                }
                
                continuation.onTermination = { _ in
                    tokenBox.token?.invalidate()
                    tokenBox.token = nil
                }
                
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }
    
    func observeArticle(id: Int) -> AsyncThrowingStream<Article?, Error> {
        AsyncThrowingStream { continuation in
            do {
                let realm = try realmProvider.makeRealm()
                let results = realm.objects(RealmArticleObject.self)
                    .where { $0.id == id }

                let tokenBox = NotificationTokenBox()
                tokenBox.token = results.observe { [mapper] change in
                    switch change {
                    case let .initial(collection):
                        continuation.yield(collection.first.map(mapper.realmToDomain))
                    case let .update(collection, _, _, _):
                        continuation.yield(collection.first.map(mapper.realmToDomain))
                    case let .error(error):
                        continuation.finish(throwing: error)
                    }
                }

                continuation.onTermination = { _ in
                    tokenBox.token?.invalidate()
                    tokenBox.token = nil
                }
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }
    
    func upsert(articles: [Article]) throws {
        guard !articles.isEmpty else { return }
        
        let realm = try realmProvider.makeRealm()
        let objects = articles.map(mapper.domainToRealm)
        
        try realm.write {
            realm.add(objects, update: .modified)
        }
        
    }
    
    func upsert(article: Article) throws {
        let realm = try realmProvider.makeRealm()
        let object = mapper.domainToRealm(article)
        
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
}

//
//  ArticleRepositoryImpl.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation

final class ArticleRepositoryImpl {
    private let remoteDataSource: ArticleRemoteDataSource
    private let localDataSource: ArticleLocalDataSource
    private let mapper: ArticleDataMapper

    init(remoteDataSource: ArticleRemoteDataSource,
         localDataSource: ArticleLocalDataSource,
         mapper: ArticleDataMapper) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.mapper = mapper
    }
    
}

extension ArticleRepositoryImpl: ObserveArticlesRepository {
    func observeArticles() -> AsyncThrowingStream<[Article], Error> {
        localDataSource.observeArticles()
    }
}

extension ArticleRepositoryImpl: ObserveArticleDetailRepository {
    func observeArticle(id: Int) -> AsyncThrowingStream<Article?, Error> {
        localDataSource.observeArticle(id: id)
    }
}

extension ArticleRepositoryImpl: RefreshArticlesRepository {
    func refreshArticles() async throws {
        do {
            let remoteArticles = try await remoteDataSource.fetchArticles(limit: 40)
            let mapped = remoteArticles.map(mapper.dtoToDomain)
            try localDataSource.upsert(articles: mapped)
        } catch {
            throw error
        }
    }
}

extension ArticleRepositoryImpl: RefreshArticleRepository {
    func refreshArticle(id: Int) async throws {
        do {
            let remoteArticle = try await remoteDataSource.fetchArticle(id: id)
            let mapped = mapper.dtoToDomain(remoteArticle)
            try localDataSource.upsert(article: mapped)
        } catch {
            throw error
        }
    }
}


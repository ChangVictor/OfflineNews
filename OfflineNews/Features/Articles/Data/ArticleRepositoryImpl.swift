//
//  ArticleRepositoryImpl.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation

final class ArticleRepositoryImpl {
    private let remoteDataSource: ArticleRemoteDataSource
    
    init(remoteDataSource: ArticleRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
}

extension ArticleRepositoryImpl: ObserveArticlesRepository {
    func observeArticles() -> AsyncThrowingStream<[Article], Error> {
        
    }
}

extension ArticleRepositoryImpl: ObserveArticleDetailRepository {
    func observeArticle(id: Int) -> AsyncThrowingStream<Article?, Error> {
        
    }
}

extension ArticleRepositoryImpl: RefreshArticlesRepository {
    func refreshArticles() async throws {
        
    }
}

extension ArticleRepositoryImpl: RefreshArticleRepository {
    func refreshArticle(id: Int) async throws {
        
    }
}


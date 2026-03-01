//
//  ArticleRepository.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation

protocol ObserveArticlesRepository {
    func observeArticles() -> AsyncThrowingStream<[Article], Error>
}

protocol ObserveArticleDetailRepository {
    func observeArticle(id: Int) -> AsyncThrowingStream<Article?, Error>
}

protocol RefreshArticlesRepository {
    func refreshArticles() async throws
}

protocol RefreshArticleRepository {
    func refreshArticle(id: Int) async throws
}

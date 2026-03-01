//
//  RefreshArticleUseCase.swift
//  OfflineNews
//
//  Created by Victor Chang on 28/2/26.
//

import Foundation

struct RefreshArticlesUseCase {
    private let repository: ArticleRepository

    init(repository: ArticleRepository) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.refreshArticles()
    }
}

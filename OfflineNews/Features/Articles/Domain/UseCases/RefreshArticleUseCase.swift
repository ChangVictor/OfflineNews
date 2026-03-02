//
//  RefreshArticleUseCase.swift
//  OfflineNews
//
//  Created by Victor Chang on 2/3/26.
//

import Foundation

struct RefreshArticleUseCase {
    private let repository: RefreshArticleRepository

    init(repository: RefreshArticleRepository) {
        self.repository = repository
    }

    func execute(articleID: Int) async throws {
        try await repository.refreshArticle(id: articleID)
    }
}

//
//  RefreshArticlesUseCase.swift
//  OfflineNews
//
//  Created by Victor Chang on 28/2/26.
//

import Foundation

struct RefreshArticlesUseCase {
    private let repository: RefreshArticlesRepository

    init(repository: RefreshArticlesRepository) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.refreshArticles()
    }
}

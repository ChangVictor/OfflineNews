//
//  ObserveArticlesUseCase.swift
//  OfflineNews
//
//  Created by Victor Chang on 28/2/26.
//

import Foundation

struct ObserveArticlesUseCase {
    private let repository: ObserveArticlesRepository

    init(repository: ObserveArticlesRepository) {
        self.repository = repository
    }

    func execute() -> AsyncThrowingStream<[Article], Error> {
        repository.observeArticles()
    }
}

//
//  ObserveArticleUseCase.swift
//  OfflineNews
//
//  Created by Victor Chang on 2/3/26.
//

import Foundation

struct ObserveArticleDetailUseCase {
    private let repository: ObserveArticleDetailRepository

    init(repository: ObserveArticleDetailRepository) {
        self.repository = repository
    }

    func execute(articleID: Int) -> AsyncThrowingStream<Article?, Error> {
        repository.observeArticle(id: articleID)
    }
}

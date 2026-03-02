//
//  ArticleDetailViewModel.swift
//  OfflineNews
//
//  Created by Victor Chang on 2/3/26.
//

import Foundation
import Combine

@MainActor
final class ArticleDetailViewModel: ObservableObject {
    @Published private(set) var article: Article?
    @Published private(set) var isLoading = true
    @Published var errorMessage: String?
    
    private let articleId: Int
    private let observeArticleUseCase: ObserveArticleDetailUseCase
    private let refreshArticleUseCase: RefreshArticleUseCase
    
    private var observationTask: Task<Void, Never>?
    
    init(articleId: Int,
         observeArticleUseCase: ObserveArticleDetailUseCase,
         refreshArticleUseCase: RefreshArticleUseCase) {
        self.articleId = articleId
        self.observeArticleUseCase = observeArticleUseCase
        self.refreshArticleUseCase = refreshArticleUseCase
    }
    
    deinit {
        observationTask?.cancel()
    }
    
    func start() {
        guard observationTask == nil else { return }
        
        observationTask = Task { [weak self] in
            await self?.observeArticle()
        }
    }
    
    func refresh() async {
        do {
            try await refreshArticleUseCase.execute(articleID: articleId)
        } catch {
            if article == nil {
                setError(error)
            }
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    private func observeArticle() async {
        do {
            for try await article in observeArticleUseCase.execute(articleID: articleId) {
                self.article = article
                isLoading = false
            }
        } catch {
            setError(error)
            isLoading = false
        }
    }
    
    private func setError(_ error: Error) {
        let fallback = "Something went wrong while loading this article."
        errorMessage = (error as? LocalizedError)?.errorDescription ?? fallback
    }
}

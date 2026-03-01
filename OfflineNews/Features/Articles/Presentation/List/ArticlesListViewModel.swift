//
//  ArticlesListViewModel.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation
import Combine

@MainActor
final class ArticlesListViewModel: ObservableObject {
    @Published private(set) var articles: [Article] = []
    @Published private(set) var isInitialLoading = true
    @Published private(set) var isRefreshing = false
    @Published var errorMessage: String?

    
    private let observeArticlesUseCase: ObserveArticlesUseCase
    private let refreshArticlesUseCase: RefreshArticlesUseCase
    
    private var observationTask: Task<Void, Never>?

    init(observeArticlesUseCase: ObserveArticlesUseCase,
         refreshArticlesUseCase: RefreshArticlesUseCase) {
        self.observeArticlesUseCase = observeArticlesUseCase
        self.refreshArticlesUseCase = refreshArticlesUseCase
    }
    
    deinit {
        observationTask?.cancel()
    }
    
    func start() {
        guard observationTask == nil else { return }
        observationTask = Task { [weak self] in
            await self?.observeArticles()
        }
        
        Task { [weak self] in
            await self?.refresh()
        }
    }
    
    func refresh() async {
        guard !isRefreshing else { return }

        isRefreshing = true
        defer { isRefreshing = false }

        do {
            try await refreshArticlesUseCase.execute()
        } catch {
            setError(error)
            isInitialLoading = false
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    private func observeArticles() async {
        do {
            for try await articles in observeArticlesUseCase.execute() {
                self.articles = articles
                isInitialLoading = false
            }
        } catch {
            setError(error)
            isInitialLoading = false
        }
    }
    
    private func setError(_ error: Error) {
        let fallback = "Something went wrong while loading articles."
        errorMessage = (error as? LocalizedError)?.errorDescription ?? fallback
    }
    
}

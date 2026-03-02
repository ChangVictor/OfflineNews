//
//  AppDIContainer.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation

final class AppDIContainer {
    private let articleRepository: ArticleRepositoryImpl
    
    init() {
        let apiClient = URLSessionAPIClient(baseURL: URL(string: "https://api.spaceflightnewsapi.net/v4")!,
                                            session: .shared)
        let mapper = ArticleDataMapper()
        let remoteDataSource = SpaceFlightArticleRemoteDataSource(apiClient: apiClient)
        
        let realmProvider = RealmProvider(configuration: RealmConfigurationFactory.make())

        let localDataSource = RealmArticleLocalDataSource(realmProvider: realmProvider, mapper: mapper)
        
        articleRepository = ArticleRepositoryImpl(remoteDataSource: remoteDataSource,
                                                  localDataSource: localDataSource,
                                                  mapper: mapper)
    }
    
    @MainActor
    func makeArticlesListViewModel() -> ArticlesListViewModel {
        ArticlesListViewModel(
            observeArticlesUseCase: ObserveArticlesUseCase(repository: articleRepository),
            refreshArticlesUseCase: RefreshArticlesUseCase(repository: articleRepository)
        )
    }

}

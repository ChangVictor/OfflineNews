//
//  AppRouter.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import SwiftUI

@MainActor
struct AppRouter: View {
    private let container: AppDIContainer

    init(container: AppDIContainer = AppDIContainer()) {
        self.container = container
    }

    var body: some View {
        ArticleListView(
            viewModel: container.makeArticlesListViewModel())
            }
        
    }


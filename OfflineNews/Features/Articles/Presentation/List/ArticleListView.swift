//
//  ArticleListView.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import SwiftUI

struct ArticleListView: View {
    @StateObject var viewModel: ArticlesListViewModel
    
    init(viewModel: ArticlesListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isInitialLoading, viewModel.articles.isEmpty {
                    ProgressView("Loading Articles...")
                } else if viewModel.articles.isEmpty {
                    ContentUnavailableView("No Articles Available",
                                           systemImage: "doc.text.magnifyingglass",
                                            description: Text("Pull to try again"))
                } else {
                    List(viewModel.articles) { article in
                        NavigationLink(value: article.id) {
                             ArticleListItemView(article: article)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Articles")
            .navigationDestination(for: Int.self) { articleId in
                // ArticleDetailView(viewModel: )
            }
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                viewModel.start()
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.clearError()
                    }
                }
            )) {
                Button("OK", role: .cancel) {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }
}

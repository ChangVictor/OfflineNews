//
//  ArticleDetailView.swift
//  OfflineNews
//
//  Created by Victor Chang on 2/3/26.
//

import SwiftUI

struct ArticleDetailView: View {
    @StateObject private var viewModel: ArticleDetailViewModel

    init(viewModel: ArticleDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading, viewModel.article == nil {
                ProgressView("Loading article...")
            } else if let article = viewModel.article {
                GeometryReader { proxy in
                    let cardWidth = max(proxy.size.width - 32, 0)
                    let contentWidth = max(cardWidth - 36, 0)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 16) {
                                if let imageURL = article.imageURL {
                                    AsyncImage(url: imageURL) { phase in
                                        switch phase {
                                        case let .success(image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        case .failure:
                                            Color.secondary.opacity(0.1)
                                                .overlay(Image(systemName: "photo"))
                                        case .empty:
                                            ProgressView()
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .frame(width: contentWidth)
                                    .frame(height: 230)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                }

                                Text(article.title)
                                    .font(.title2.weight(.bold))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                HStack(spacing: 10) {
                                    Label(article.author, systemImage: "person.fill")
                                    Text("•")
                                    Text(article.publishedAt.articleDisplayText)
                                }
                                .font(.footnote)
                                .foregroundStyle(.secondary)

                                Divider()

                                Text(article.content)
                                    .font(.body)
                                    .lineSpacing(4)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)

                                if let articleURL = article.articleURL {
                                    Link("Read original article", destination: articleURL)
                                        .font(.footnote.weight(.semibold))
                                        .padding(.top, 4)
                                }
                            }
                            .padding(18)
                            .frame(width: cardWidth, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color(uiColor: .secondarySystemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
            } else {
                ContentUnavailableView(
                    "Article Not Available",
                    systemImage: "doc.text",
                    description: Text("This article is not cached yet. Pull to refresh from the list.")
                )
            }
        }
        .navigationTitle("Article Detail")
        .navigationBarTitleDisplayMode(.inline)
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

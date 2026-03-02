//
//  ArticleListItemView.swift
//  OfflineNews
//
//  Created by Victor Chang on 2/3/26.
//

import SwiftUI

struct ArticleListItemView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(article.title)
                .font(.headline.weight(.semibold))
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            Text(article.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            HStack {
                Label(article.author, systemImage: "person.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                Spacer()
                
                Text(article.publishedAt.articleDisplayText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
    }
}

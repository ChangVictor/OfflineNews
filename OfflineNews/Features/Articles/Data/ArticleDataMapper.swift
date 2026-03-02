//
//  ArticleDataMapper.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation

struct ArticleDataMapper {
    func dtoToDomain(_ dto: ArticleDTO) -> Article {
        let author = dto.authors?.compactMap { $0.name?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first(where: { !$0.isEmpty }) ?? "Unknown"
    
        let summary = dto.summary ?? ""
        
        return Article(id: dto.id,
                       title: dto.title,
                       summary: summary,
                       content: summary,
                       author: author,
                       publishedAt: dto.publishedAt,
                       newsSite: dto.newsSite ?? "",
                       articleURL: URL(string: dto.url ?? ""),
                       imageURL: URL(string: dto.imageUrl ?? ""))
    }
    
    func realmToDomain(_ object: RealmArticleObject) -> Article {
        return Article(id: object.id,
                title: object.title,
                summary: object.summary,
                content: object.content,
                author: object.author,
                publishedAt: object.publishedAt,
                newsSite: object.newsSite,
                articleURL: URL(string: object.articleURLString),
                imageURL: URL(string: object.imageURLString))
    }
    
    func domainToRealm(_ article: Article) -> RealmArticleObject {
        let object = RealmArticleObject()
        object.id = article.id
        object.title = article.title
        object.summary = article.summary
        object.content = article.content
        object.author = article.author
        object.publishedAt = article.publishedAt
        object.newsSite = article.newsSite
        object.articleURLString = article.articleURL?.absoluteString ?? ""
        object.imageURLString = article.imageURL?.absoluteString ?? ""
        return object
    }
}

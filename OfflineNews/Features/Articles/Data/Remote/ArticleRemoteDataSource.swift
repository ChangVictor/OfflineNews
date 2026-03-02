//
//  ArticleRemoteDataSource.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation

protocol ArticleRemoteDataSource {
    func fetchArticles(limit: Int) async throws -> [ArticleDTO]
    func fetchArticle(id: Int) async throws -> ArticleDTO
}

final class SpaceFlightArticleRemoteDataSource: ArticleRemoteDataSource {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchArticles(limit: Int) async throws -> [ArticleDTO] {
        let response: ArticlesResponseDTO = try await apiClient.getArticles(
            path: "articles",
            queryItems: [URLQueryItem(name: "limit", value: (String(limit)))])
        return response.results
    }
    
    func fetchArticle(id: Int) async throws -> ArticleDTO {
        try await apiClient.getArticles(path: "articles/\(id)", queryItems: [])
    }
}



struct ArticlesResponseDTO: Decodable {
    let results: [ArticleDTO]
}

struct ArticleDTO: Decodable {
    struct AuthorDTO: Decodable {
        let name: String?
    }

    let id: Int
    let title: String
    let summary: String?
    let url: String?
    let imageUrl: String?
    let newsSite: String?
    let publishedAt: Date
    let authors: [AuthorDTO]?
}


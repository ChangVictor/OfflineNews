//
//  APIClient.swift
//  OfflineNews
//
//  Created by Victor Chang on 28/2/26.
//

import Foundation
 
protocol APIClient {
    func getArticles<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> T
}

final class URLSessionAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession
    
    init(baseURL: URL, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func getArticles<T>(path: String, queryItems: [URLQueryItem]) async throws -> T where T : Decodable {
        guard var componenets = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        componenets.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = componenets.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200 ..< 300).contains(httpResponse.statusCode) else {
            throw APIError.httpStatus(httpResponse.statusCode)
        }
        
        do {
            return try makeDecoder().decode(T.self, from: data)
        } catch {

            throw APIError.decoding(error)
        }
        
    }
    
    private func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)

            if let date = Self.parseISO8601Date(rawValue) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid ISO8601 date: \(rawValue)"
            )
        }

        return decoder
    }
    
    private static func parseISO8601Date(_ rawValue: String) -> Date? {
        let withFractionalSeconds = ISO8601DateFormatter()
        withFractionalSeconds.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = withFractionalSeconds.date(from: rawValue) {
            return date
        }

        let withoutFractionalSeconds = ISO8601DateFormatter()
        withoutFractionalSeconds.formatOptions = [.withInternetDateTime]
        return withoutFractionalSeconds.date(from: rawValue)
    }

}

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."
        case .invalidResponse:
            return "The API returned an invalid response."
        case let .httpStatus(statusCode):
            return "The API request failed with status code \(statusCode)."
        case .decoding:
            return "Failed to decode the API response."
        }
    }
}

//
//  Article.swift
//  OfflineNews
//
//  Created by Victor Chang on 28/2/26.
//

import Foundation

struct Article: Identifiable, Equatable {
    let id: Int
    let title: String
    let summary: String
    let content: String
    let author: String
    let publishedAt: Date
    let newsSite: String
    let articleURL: URL?
    let imageURL: URL?
}

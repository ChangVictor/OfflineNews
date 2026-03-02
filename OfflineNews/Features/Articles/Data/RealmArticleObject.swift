//
//  RealmArticleObject.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation
@preconcurrency import RealmSwift

final class RealmArticleObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String = ""
    @Persisted var summary: String = ""
    @Persisted var content: String = ""
    @Persisted var author: String = ""
    @Persisted var newsSite: String = ""
    @Persisted var publishedAt: Date = .distantPast
    @Persisted var articleURLString: String = ""
    @Persisted var imageURLString: String = ""
}

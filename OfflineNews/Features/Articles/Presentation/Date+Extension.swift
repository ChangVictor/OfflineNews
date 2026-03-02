//
//  Date+Extension.swift
//  OfflineNews
//
//  Created by Victor Chang on 2/3/26.
//

import Foundation

extension Date {
    var articleDisplayText: String {
        Date.articleDateFormatter.string(from: self)
    }

    private static let articleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

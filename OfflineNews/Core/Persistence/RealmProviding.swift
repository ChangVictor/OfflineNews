//
//  RealmProviding.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation
@preconcurrency import RealmSwift


protocol RealmProviding {
    func makeRealm() throws -> Realm
}

final class RealmProvider: RealmProviding {
    private let configuration: Realm.Configuration
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }
    
    func makeRealm() throws -> Realm {
        try Realm(configuration: configuration)
    }
}

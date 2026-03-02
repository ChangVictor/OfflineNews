//
//  RealmConfigurationFactory.swift
//  OfflineNews
//
//  Created by Victor Chang on 1/3/26.
//

import Foundation

@preconcurrency import RealmSwift

enum RealmConfigurationFactory {
    static func make() -> Realm.Configuration {
        Realm.Configuration(schemaVersion: 1,
                            migrationBlock: { _, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                // TODO: - handle initial migration placeholder for furutre schema updates
            }
        })
    }
}

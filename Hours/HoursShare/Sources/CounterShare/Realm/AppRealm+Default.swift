//
//  File.swift
//
//
//  Created by 张敏超 on 2024/8/6.
//

import Foundation
import RealmSwift

public extension AppRealm {
    func importDefaults(categories: [CategoryEntity]) async {
        let realm = await realm
        for category in categories {
            if let object = realm.objects(CategoryObject.self).where({ $0.name == category.name && $0.emoji == category.emoji }).first {
                try? await realm.asyncWrite {
                    object.events.append(objectsIn: category.events.map { $0.toObject() })
                }
            } else {
                try? await realm.asyncWrite {
                    realm.add(category.toObject())
                }
            }
        }
    }
}

//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/5.
//

import ClockShare
import Foundation
import IdentifiedCollections
import OrderedCollections
import RealmSwift

public extension AppRealm {
    func writeCategory(_ entity: CategoryEntity) async {
        do {
            let realm = await realm
            if realm.object(ofType: CategoryObject.self, forPrimaryKey: entity._id) != nil {
                try await realm.asyncWrite {
                    realm.add(entity.toObject(), update: .modified)
                }
            } else {
                try await realm.asyncWrite {
                    realm.add(entity.toObject())
                }
            }
        } catch {
            debugPrint(error)
        }
    }

    /// 应用首页调用这个方法，没有分类或者事件时，重新写入
    func getAllUnarchivedCategories() async -> [CategoryEntity] {
        do {
            let realm = await realm
            var categories = realm.objects(CategoryObject.self)
            if categories.isEmpty {
                // 写入默认的分类
                try await realm.asyncWrite {
                    let defaluts = CategoryObject.defaults
                    for item in defaluts {
                        realm.add(item)
                    }
                }
                categories = realm.objects(CategoryObject.self)
            }
            categories = categories.where { $0.archivedAt == nil && $0.deletedAt == nil }

            var entities = [CategoryEntity]()
            for category in categories {
                let events: [EventEntity] = category.events
                    .where { $0.deletedAt == nil && $0.archivedAt == nil }
                    .map { EventEntity(object: $0, isLinkedObject: true) }

                var entity = CategoryEntity(object: category, isLinkedObject: true)
                entity.events = events
                entities.append(entity)
            }

            return entities
        } catch {
            debugPrint(error)
            return []
        }
    }

    func getAllArchivedCategories() async -> [CategoryEntity] {
        let realm = await realm
        let categories = realm
            .objects(CategoryObject.self)
            .where { $0.deletedAt == nil }

        var entities = [CategoryEntity]()
        for category in categories {
            let events: [EventEntity] = category.events
                .where { $0.deletedAt == nil && $0.archivedAt != nil }
                .map { EventEntity(object: $0, isLinkedObject: true) }
            if events.isEmpty { continue }

            var entity = CategoryEntity(object: category, isLinkedObject: true)
            entity.events = events
            entities.append(entity)
        }
        return entities
    }

    func writeCalendarIdentifier(_ id: String, for entity: CategoryEntity) async {
        let realm = await realm
        guard let object = realm.object(ofType: CategoryObject.self, forPrimaryKey: entity._id) else { return }

        do {
            try await realm.asyncWrite {
                object.calendarIdentifier = id
            }
        } catch {
            debugPrint(error)
        }
    }

    func healthCategory() async -> CategoryEntity {
        let realm = await realm
        if let health = realm.objects(CategoryObject.self).first(where: { $0.name == R.string.localizable.health() }) {
            return CategoryEntity(object: health)
        } else {
            let category = await CategoryEntity(hex: nextHex, emoji: "❤️", name: R.string.localizable.health())
            try? await realm.asyncWrite {
                realm.add(category.toObject())
            }
            return category
        }
    }
}

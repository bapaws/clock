//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/5.
//

import ClockShare
import CloudKit
import EventKit
import Foundation
import IdentifiedCollections
import OrderedCollections
import RealmSwift

public extension AppRealm {
    func writeCategory(_ entity: CategoryEntity) async {
        do {
            let realm = await realm
            if let object = realm.object(ofType: CategoryObject.self, forPrimaryKey: entity._id) {
                try await realm.asyncWrite {
                    if object.hex?._id != entity.hex?._id {
                        object.hex = entity.hex?.toObject()
                    }
                    object.emoji = entity.emoji
                    object.icon = entity.icon
                    object.name = entity.name
                    object.calendarIdentifier = entity.calendarIdentifier
                    object.index = entity.index
                    object.createdAt = entity.createdAt
                    object.deletedAt = entity.deletedAt
                    object.archivedAt = entity.archivedAt
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

    func createOrUpdateCategory(by record: CKRecord) async throws {
        let entity = try CategoryEntity(ckRecord: record)
        await AppRealm.shared.writeCategory(entity)
    }

    /// 应用首页调用这个方法，没有分类或者事件时，重新写入
    func getAllUnarchivedCategories() async -> [CategoryEntity] {
        do {
            let realm = await realm
            var categories = realm.objects(CategoryObject.self)
            if categories.isEmpty {
                // 写入默认的分类
//                try await realm.asyncWrite {
//                    let defaluts = CategoryObject.defaults
//                    for item in defaluts {
//                        realm.add(item)
//                    }
//                }
//                categories = realm.objects(CategoryObject.self)
            }
            categories = categories
                .where { $0.archivedAt == nil && $0.deletedAt == nil }
                .sorted(by: \.index)

            var entities = [CategoryEntity]()
            for category in categories {
                var entity = CategoryEntity(object: category, isLinkedObject: true)
                entity.eventTotalCount = category.events.count
                entity.events = category.events
                    .where { $0.deletedAt == nil && $0.archivedAt == nil }
                    .sorted(by: \.index)
                    .map { EventEntity(object: $0, isLinkedObject: true) }
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
            .sorted(by: \.index)

        var entities = [CategoryEntity]()
        for category in categories {
            let events: [EventEntity] = category.events
                .where { $0.deletedAt == nil && $0.archivedAt != nil }
                .sorted(by: \.index)
                .map { EventEntity(object: $0, isLinkedObject: true) }
            if events.isEmpty { continue }

            var entity = CategoryEntity(object: category, isLinkedObject: true)
            entity.events = events
            entities.append(entity)
        }
        return entities
    }

    func getCategory(by id: ObjectId) async -> CategoryEntity? {
        guard let object = await realm.object(ofType: CategoryObject.self, forPrimaryKey: id) else { return nil }
        return CategoryEntity(object: object)
    }

    func getCategories(where: (Query<CategoryObject>) -> Query<Bool>) async -> [CategoryEntity] {
        await realm
            .objects(CategoryObject.self)
            .where(`where`)
            .map { CategoryEntity(object: $0) }
    }

    func getCategory(by calendar: EKCalendar) async -> CategoryEntity? {
        let title = calendar.title.trimmingCharacters(in: .whitespacesAndNewlines)
        return await realm.objects(CategoryObject.self).first {
            $0.calendarIdentifier == calendar.calendarIdentifier ||
                $0.title == title ||
                $0.name == title
        }
        .map { CategoryEntity(object: $0) }
    }

    /// Soft delete
    func deleteCategory(_ entity: CategoryEntity) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: CategoryObject.self, forPrimaryKey: entity._id) else { return }
            try await realm.asyncWrite {
                for event in object.events {
                    for item in event.items {
                        item.deletedAt = .now
                    }
                    event.hex?.deletedAt = .now
                    event.deletedAt = .now
                }
                object.hex?.deletedAt = .now
                object.deletedAt = .now
            }
        } catch {
            debugPrint(error)
        }
    }

    /// Delete from realm
    func deleteCategory(by id: ObjectId) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: CategoryObject.self, forPrimaryKey: id) else { return }
            try await realm.asyncWrite {
                for event in object.events {
                    for item in event.items {
                        realm.delete(item)
                    }
                    realm.delete(event)
                }
                realm.delete(object)
            }
        } catch {
            debugPrint(error)
        }
    }

    func deleteCategory(by id: String) async throws {
        let objectId = try ObjectId(string: id)
        await deleteCategory(by: objectId)
    }

    func archiveCategory(_ entity: CategoryEntity) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: CategoryObject.self, forPrimaryKey: entity._id) else { return }
            try await realm.asyncWrite {
                for event in object.events where object.archivedAt == nil {
                    event.archivedAt = .init()
                }
                object.archivedAt = .init()
            }
        } catch {
            debugPrint(error)
        }
    }

    func unarchiveCategory(_ entity: CategoryEntity) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: CategoryObject.self, forPrimaryKey: entity._id) else { return }
            try await realm.asyncWrite {
                for event in object.events {
                    event.archivedAt = nil
                }
                object.archivedAt = nil
            }
        } catch {
            debugPrint(error)
        }
    }

    func healthCategory() async -> CategoryEntity {
        let realm = await realm
        if let health = realm.objects(CategoryObject.self).first(where: { $0.name == L10n.health }) {
            return CategoryEntity(object: health)
        } else {
            let category = await CategoryEntity(hex: nextHex, emoji: "❤️", name: L10n.health)
            try? await realm.asyncWrite {
                realm.add(category.toObject())
            }
            return category
        }
    }

    func reorder(by entities: [CategoryEntity]) async throws {
        let realm = await realm
        try? await realm.asyncWrite {
            for (index, entity) in entities.enumerated() {
                let objectId = try ObjectId(string: entity.id)
                let object = realm.object(ofType: CategoryObject.self, forPrimaryKey: objectId)
                object?.index = index
            }
        }
    }
}

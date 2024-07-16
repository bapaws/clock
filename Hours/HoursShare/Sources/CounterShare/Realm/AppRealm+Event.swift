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
    func writeEvent(_ entity: EventEntity, addTo category: CategoryEntity) async {
        do {
            let realm = await realm
            try await realm.asyncWrite {
                var eventObject = entity.toObject()
                // 从老的 category 中删除
                if let eventCategory = entity.category,
                   let categoryObject = realm.object(ofType: CategoryObject.self, forPrimaryKey: eventCategory._id),
                   let index = categoryObject.events.firstIndex(where: { $0._id == entity._id })
                {
                    eventObject = categoryObject.events[index]
                    categoryObject.events.remove(at: index)

                    eventObject.name = entity.name
                    eventObject.emoji = entity.emoji
                    eventObject.hex = entity.hex?.toObject()
                }
                let categoryObject = realm.object(ofType: CategoryObject.self, forPrimaryKey: category._id)
                categoryObject?.events.append(eventObject)
            }
        } catch {
            debugPrint(error)
        }
    }

    func deleteEvent(_ entity: EventEntity) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: EventObject.self, forPrimaryKey: entity._id) else { return }
            try await realm.asyncWrite {
                realm.delete(object.items)
                realm.delete(object)
            }
        } catch {
            debugPrint(error)
        }
    }

    func archiveEvent(_ entity: EventEntity) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: EventObject.self, forPrimaryKey: entity._id) else { return }
            try await realm.asyncWrite {
                object.archivedAt = .init()
            }
        } catch {
            debugPrint(error)
        }
    }

    func unarchiveEvent(_ entity: EventEntity) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: EventObject.self, forPrimaryKey: entity._id) else { return }
            try await realm.asyncWrite {
                object.archivedAt = nil
                object.category.archivedAt = nil
            }
        } catch {
            debugPrint(error)
        }
    }

    internal func getEvent(by id: String) async -> EventObject? {
        do {
            let objectId = try ObjectId(string: id)
            let realm = await realm
            return realm.objects(EventObject.self)
                .where { $0._id == objectId && $0.deletedAt == nil }
                .first
        } catch {
            debugPrint(error)
            return nil
        }
    }

    func getEvent(by id: String) async -> EventEntity? {
        guard let object: EventObject = await getEvent(by: id) else { return nil }
        return EventEntity(object: object)
    }

    func getEvent(by name: String, emoji: String) async -> EventEntity? {
        let realm = await realm
        guard let object: EventObject = realm.objects(EventObject.self)
            .where({ $0.name == name && $0.emoji == emoji })
            .first
        else {
            return nil
        }
        return EventEntity(object: object)
    }

    func getRecentEvents(count: Int = 15) async -> [EventEntity] {
        let realm = await realm
        let objects = realm.objects(EventObject.self)
            .where { $0.archivedAt == nil && $0.categorys.archivedAt == nil }
            .sorted { obj1, obj2 in
                var value1 = obj1.createdAt.timeIntervalSinceNow * 0.45
                value1 -= Double(obj1.items.count) * 24 * 3600 * 0.1
                let lastItem1 = obj1.items.last(where: { $0.creationMode == .timer || $0.creationMode == .enter })
                if let end = lastItem1?.endAt.timeIntervalSinceNow {
                    value1 += end * 0.45
                } else {
                    value1 *= 2
                }
                var value2 = obj2.createdAt.timeIntervalSinceNow * 0.45
                value2 -= Double(obj2.items.count) * 24 * 3600 * 0.1
                let lastItem2 = obj2.items.last(where: { $0.creationMode == .timer || $0.creationMode == .enter })
                if let end = lastItem2?.endAt.timeIntervalSinceNow {
                    value2 += end * 0.45
                } else {
                    value2 *= 2
                }
                return value1 > value2
            }
        if objects.count > count {
            return objects[0 ..< count].map { EventEntity(object: $0) }
        } else {
            return objects.map { EventEntity(object: $0) }
        }
    }

    func reorder(by entities: [EventEntity], in _: CategoryEntity) async throws {
        let realm = await realm
        try? await realm.asyncWrite {
            for (index, entity) in entities.enumerated() {
                let objectId = try ObjectId(string: entity.id)
                guard let object = realm.object(ofType: EventObject.self, forPrimaryKey: objectId) else { continue }

                // 判断是否更改了分类
                if let categoryID = entity.category?.id,
                   object.category._id.stringValue != categoryID,
                   let index = object.category.events.firstIndex(where: { $0._id == objectId })
                {
                    // 从原来的分类中移除
                    let eventObject = object.category.events[index]
                    object.category.events.remove(at: index)

                    // 添加到新的分类中
                    let categoryObjectId = try ObjectId(string: categoryID)
                    let category = realm.object(ofType: CategoryObject.self, forPrimaryKey: categoryObjectId)
                    category?.events.append(eventObject)
                }

                object.index = index
            }
        }
    }
}

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
                    // 防止数据导入时，category 被删除
                    categoryObject.deletedAt = nil

                    eventObject = categoryObject.events[index]
                    categoryObject.events.remove(at: index)

                    eventObject.name = entity.name
                    eventObject.emoji = entity.emoji
                    if eventObject.hex?._id != entity.hex?._id {
                        eventObject.hex = entity.hex?.toObject()
                    }
                    eventObject.isSystem = entity.isSystem
                    eventObject.archivedAt = entity.archivedAt

                    // 写入时，业务上只能是将删除标记设置成 nil
                    eventObject.deletedAt = nil
                }
                let categoryObject = realm.object(ofType: CategoryObject.self, forPrimaryKey: category._id)
                categoryObject?.events.append(eventObject)
            }
        } catch {
            debugPrint(error)
        }
    }

    func createOrUpdateEvent(by record: CKRecord) async throws {
        let entity = try EventEntity(ckRecord: record)
        guard
            let categoryID = entity.categoryID,
            let category = await AppRealm.shared.getCategory(by: categoryID)
        else {
            return
        }
        await AppRealm.shared.writeEvent(entity, addTo: category)
    }

    func deleteEvent(_ entity: EventEntity) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: EventObject.self, forPrimaryKey: entity._id) else { return }
            try await realm.asyncWrite {
                object.hex?.deletedAt = .now
                object.deletedAt = .now
                for item in object.items {
                    item.deletedAt = .now
                }
            }
        } catch {
            debugPrint(error)
        }
    }

    func deleteEvent(by id: ObjectId) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: EventObject.self, forPrimaryKey: id) else { return }
            try await realm.asyncWrite {
                for item in object.items {
                    realm.delete(item)
                }
                realm.delete(object)
            }
        } catch {
            debugPrint(error)
        }
    }

    func deleteEvent(by id: String) async throws {
        let objectId = try ObjectId(string: id)
        await deleteEvent(by: objectId)
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
                object.category?.archivedAt = nil
            }
        } catch {
            debugPrint(error)
        }
    }

    internal func getEvent(by id: String) async -> EventObject? {
        do {
            let objectId = try ObjectId(string: id)
            let realm = await realm
            return realm.object(ofType: EventObject.self, forPrimaryKey: objectId)
        } catch {
            debugPrint(error)
            return nil
        }
    }

    func getEvent(by id: String) async -> EventEntity? {
        guard let object: EventObject = await getEvent(by: id) else { return nil }
        return EventEntity(object: object)
    }

    func getEvent(by name: String, emoji: String?) async -> EventEntity? {
        let realm = await realm
        guard let object: EventObject = realm.objects(EventObject.self)
            .where({
                $0.name == name &&
                    $0.emoji == emoji &&
                    $0.deletedAt == nil
            })
            .first
        else {
            return nil
        }
        return EventEntity(object: object)
    }

    func getEvent(by event: EKEvent) async -> EventEntity? {
        await realm.objects(EventObject.self)
            .first { $0.title == event.title || $0.name == event.title }
            .map { EventEntity(object: $0, isLinkedObject: true) }
    }

    func getRecentEvents(count: Int = 15) async -> [EventEntity] {
        let realm = await realm
        let objects = realm.objects(EventObject.self)
            .where {
                $0.archivedAt == nil &&
                    $0.categorys.archivedAt == nil &&
                    $0.categorys.deletedAt == nil &&
                    $0.deletedAt == nil
            }
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
                   let categoryObject = object.category,
                   categoryObject._id.stringValue != categoryID,
                   let index = categoryObject.events.firstIndex(where: { $0._id == objectId })
                {
                    // 从原来的分类中移除
                    let eventObject = categoryObject.events[index]
                    categoryObject.events.remove(at: index)

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

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
                for item in object.items {
                    realm.delete(item)
                }
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
                object.archivedAt = object.archivedAt == nil ? .init() : nil
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
            .where { $0.archivedAt == nil }
            .sorted { obj1, obj2 in
                var value1 = obj1.createdAt.timeIntervalSinceNow * 0.4
                value1 -= Double(obj1.items.count) * 24 * 3600 * 0.2
                if let end = obj1.items.last?.endAt.timeIntervalSinceNow {
                    value1 += end * 0.4
                } else {
                    value1 *= 2
                }
                var value2 = obj2.createdAt.timeIntervalSinceNow * 0.5
                value2 -= Double(obj2.items.count) * 24 * 3600 * 0.2
                if let end = obj2.items.last?.endAt.timeIntervalSinceNow {
                    value2 += end * 0.4
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
}

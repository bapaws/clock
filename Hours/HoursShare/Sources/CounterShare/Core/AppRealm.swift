//
//  File.swift
//
//
//  Created by 张敏超 on 2024/6/5.
//

import ClockShare
import Foundation
import IdentifiedCollections
import OrderedCollections
import RealmSwift
import SwiftUIX

public actor AppRealm {
    public static let shared = AppRealm()

    // MARK: Realm

    public let schemaVersion: UInt64 = 7
    public let fileName = "default"

    private var _realm: Realm?
    public var realm: Realm {
        get async {
            if let _realm { return _realm }
            do {
                // 老版本数据配置
                let originalConfig = Realm.Configuration(schemaVersion: schemaVersion)
                let fileManager = FileManager.default

                guard let fileURL = Storage.default.groupURL?.appendingPathComponent(fileName) else {
                    _realm = try await Realm(configuration: originalConfig, actor: self)
                    return _realm!
                }

                if let originalFileURL = originalConfig.fileURL, fileManager.fileExists(atPath: originalFileURL.path), !fileManager.fileExists(atPath: fileURL.path) {
                    try fileManager.moveItem(at: originalFileURL, to: fileURL)
                }

                let config = Realm.Configuration(
                    fileURL: fileURL,
                    schemaVersion: schemaVersion
                )
                Realm.Configuration.defaultConfiguration = config
                _realm = try await Realm(configuration: config, actor: self)
            } catch {
                debugPrint(error)
            }

            return _realm!
        }
    }

    // MARK: HEX

    public lazy var hexs: [HexEntity] = []
    private lazy var hexIndex = Storage.default.hexIndex ?? 27 {
        didSet { Storage.default.hexIndex = hexIndex }
    }
}

// MARK: Category

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

// MARK: Event

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

    private func getEvent(by id: String) async -> EventObject? {
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
}

// MARK: Record

public extension AppRealm {
    func writeRecord(_ entity: RecordEntity, addTo event: EventEntity) async {
        do {
            guard let eventObject: EventObject = await getEvent(by: event.id) else { return }
            try await realm.asyncWrite {
                let object = entity.toObject()
                eventObject.items.append(object)
            }
        } catch {
            debugPrint(error)
        }
    }

    func writeRecords(_ entities: [RecordEntity], addTo event: EventEntity) async {
        do {
            guard let eventObject: EventObject = await getEvent(by: event.id) else { return }
            try await realm.asyncWrite {
                for entity in entities {
                    let object = entity.toObject()
                    eventObject.items.append(object)
                }
            }
        } catch {
            debugPrint(error)
        }
    }

    func updateRecord(_ entity: RecordEntity) async {
        do {
            let realm = await realm
            try await realm.asyncWrite {
                let object = entity.toObject()
                realm.add(object, update: .modified)
            }
        } catch {
            debugPrint(error)
        }
    }

    func deleteRecord(_ entity: RecordEntity) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: RecordObject.self, forPrimaryKey: entity._id) else { return }
            try await realm.asyncWrite {
                realm.delete(object)
            }
        } catch {
            debugPrint(error)
        }
    }

    func getRecord(of entity: EventEntity, minEndAt: Date) async -> RecordEntity? {
        return await getRecords(where: { $0.events._id == entity._id && $0.endAt > minEndAt }).first
    }

    func getRecords(where: (Query<RecordObject>) -> Query<Bool>, sortedBy areInIncreasingOrder: ((RecordEntity, RecordEntity) -> Bool)? = nil) async -> [RecordEntity] {
        await realm
            .objects(RecordObject.self)
            .where(`where`)
            .map { RecordEntity(object: $0) }
            .sorted(by: areInIncreasingOrder ?? { $0.endAt > $1.endAt })
    }

    func containsRecord(where: (Query<RecordObject>) -> Query<Bool>) async -> Bool {
        await !getRecords(where: `where`).isEmpty
    }

    func sectionedRecords<Key: _Persistable & Hashable>(_ entity: EventEntity, by block: @escaping ((RecordObject) -> Key)) async -> OrderedDictionary<Key, [RecordEntity]> {
        var results = OrderedDictionary<Key, [RecordEntity]>()
        guard let eventObject: EventObject = await getEvent(by: entity.id) else { return results }
        let sectionedResults = eventObject.items.sectioned(
            by: block,
            sortDescriptors: [SortDescriptor(keyPath: \RecordObject.endAt, ascending: false)]
        )
        for result in sectionedResults {
            let records = result.map { RecordEntity(object: $0) }
            results[result.key] = records
        }
        return results
    }

    /// 包含结束时间在 startAt 和 endAt 的所有记录
    func getRecordsEndAt(from: Date, to: Date) async -> [RecordEntity] {
        await realm.objects(RecordObject.self)
            .where { $0.endAt >= from && $0.endAt <= to }
            .sorted(by: \.startAt, ascending: true)
            .map { RecordEntity(object: $0) }
    }
}

// MARK: HEX

extension AppRealm {
    private func writeHexes() async {
        let realm = await realm

        guard realm.objects(HexObject.self).isEmpty else { return }
        guard let jsonData = nipponColors.data(using: .utf8) else { return }
        do {
            let decoder = JSONDecoder()
            let colors = try decoder.decode([OneColor].self, from: jsonData)
            let hexs = colors.map { HexObject(hex: $0.hex) }
            try realm.write {
                realm.add(hexs)
            }
        } catch {
            debugPrint(error)
        }
    }

    public var nextHex: HexEntity {
        get async {
            if hexs.isEmpty {
                await writeHexes()

                let realm = await realm
                let entities = realm.objects(HexObject.self)
                    .map { HexEntity(object: $0) }
                hexs.append(contentsOf: entities)
            }

            guard !hexs.isEmpty else { return HexEntity.random }

            let hex = hexs[hexIndex % hexs.count]
            hexIndex += 1
            return hex
        }
    }
}

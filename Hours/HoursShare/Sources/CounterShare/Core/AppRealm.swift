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
    public let config = Realm.Configuration(schemaVersion: 7)

    public private(set) var realm: Realm!

    // MARK: HEX

    public lazy var hexs: [HexEntity] = []
    private lazy var hexIndex = Storage.default.hexIndex ?? 27 {
        didSet { Storage.default.hexIndex = hexIndex }
    }

    public func setup() async throws {
        if realm != nil { return }

        // 老版本数据配置
        let originalConfig = Realm.Configuration(schemaVersion: schemaVersion)
        let fileManager = FileManager.default

        guard let fileURL = Storage.default.groupURL?.appendingPathComponent(fileName) else {
            realm = try await Realm(configuration: originalConfig, actor: self)
            return
        }

        if let originalFileURL = originalConfig.fileURL, fileManager.fileExists(atPath: originalFileURL.path), !fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.moveItem(at: originalFileURL, to: fileURL)
        }

        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            fileURL: fileURL,
            schemaVersion: schemaVersion
        )
        realm = try await Realm(configuration: config, actor: self)

        writeDefaultCategories()
    }
}

// MARK: Category

public extension AppRealm {
    private func writeDefaultCategories() {
        do {
            guard realm.objects(CategoryObject.self).isEmpty else { return }

            try realm.write {
                let defaluts = CategoryObject.defaults
                for item in defaluts {
                    realm.add(item)
                }
            }
        } catch {
            debugPrint(error)
        }
    }

    func getAllUnarchivedCategories() -> [CategoryEntity] {
        let categories = realm
            .objects(CategoryObject.self)
            .where { $0.archivedAt == nil && $0.deletedAt == nil }

        var entities = [CategoryEntity]()
        for category in categories {
            let events: [EventEntity] = category.events.compactMap {
                guard $0.deletedAt == nil, $0.archivedAt == nil else { return nil }
                return EventEntity(object: $0)
            }
            var entity = CategoryEntity(object: category, isLinkedObject: true)
            entity.events = events
            entities.append(entity)
        }
        return entities
    }

    func getAllArchivedCategories() -> [CategoryEntity] {
        let categories = realm
            .objects(CategoryObject.self)
            .where { $0.archivedAt != nil }

        var entities = [CategoryEntity]()
        for category in categories {
            let events: [EventEntity] = category.events.compactMap {
                guard $0.archivedAt != nil else { return nil }
                return EventEntity(object: $0)
            }
            var entity = CategoryEntity(object: category, isLinkedObject: true)
            entity.events = events
            entities.append(entity)
        }
        return entities
    }

    func writeCalendarIdentifier(_ id: String, for entity: CategoryEntity) async {
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
        if let health = realm.objects(CategoryObject.self).first(where: { $0.name == R.string.localizable.health() }) {
            return CategoryEntity(object: health)
        } else {
            let category = CategoryEntity(hex: nextHex, emoji: "❤️", name: R.string.localizable.health())
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
            // 从老的 category 中删除
            if let eventCategory = entity.category,
               let categoryObject = realm.object(ofType: CategoryObject.self, forPrimaryKey: eventCategory._id),
               let index = categoryObject.events.firstIndex(where: { $0._id == entity._id })
            {
                categoryObject.events.remove(at: index)
            }
            let categoryObject = realm.object(ofType: CategoryObject.self, forPrimaryKey: category._id)
            try await realm.asyncWrite {
                let object = entity.toObject()
                categoryObject?.events.append(object)
            }
        } catch {
            debugPrint(error)
        }
    }

    func deleteEvent(_ entity: EventEntity) async {
        do {
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
            guard let object = realm.object(ofType: EventObject.self, forPrimaryKey: entity._id) else { return }
            try await realm.asyncWrite {
                object.archivedAt = object.archivedAt == nil ? .init() : nil
            }
        } catch {
            debugPrint(error)
        }
    }

    private func getEvent(by id: String) -> EventObject? {
        return realm.objects(EventObject.self)
            .first { $0._id.stringValue == id && $0.deletedAt == nil }
    }

    func getEvent(by id: String) -> EventEntity? {
        guard let object: EventObject = getEvent(by: id) else { return nil }
        return EventEntity(object: object)
    }

    func getEvent(by name: String, emoji: String) -> EventEntity? {
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
            guard let eventObject: EventObject = getEvent(by: event.id) else { return }
            try await realm.asyncWrite {
                let object = entity.toObject()
                eventObject.items.append(object)
            }
        } catch {
            debugPrint(error)
        }
    }

    func updateRecord(_ entity: RecordEntity) async {
        do {
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
            guard let object = realm.object(ofType: RecordObject.self, forPrimaryKey: entity._id) else { return }
            try await realm.asyncWrite {
                realm.delete(object)
            }
        } catch {
            debugPrint(error)
        }
    }

    func getRecord(of entity: EventEntity, minEndAt: Date) -> RecordEntity? {
        return getRecords(where: { $0.events._id == entity._id && $0.endAt > minEndAt }).first
    }

    func getRecords(where: (Query<RecordObject>) -> Query<Bool>) -> [RecordEntity] {
        realm.objects(RecordObject.self)
            .where(`where`).map { RecordEntity(object: $0) }
    }

    func containsRecord(where: (Query<RecordObject>) -> Query<Bool>) -> Bool {
        !getRecords(where: `where`).isEmpty
    }

    func sectionedRecords<Key: _Persistable & Hashable>(_ entity: EventEntity, by block: @escaping ((RecordObject) -> Key)) -> OrderedDictionary<Key, [RecordEntity]> {
        var results = OrderedDictionary<Key, [RecordEntity]>()
        guard let eventObject: EventObject = getEvent(by: entity.id) else { return results }
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
}

// MARK: HEX

extension AppRealm {
    private func writeHexes() {
        guard realm.objects(HexObject.self).isEmpty else { return }
        guard let jsonData = nipponColors.data(using: .utf8) else { return }
        do {
            let decoder = JSONDecoder()
            let colors = try decoder.decode([OneColor].self, from: jsonData)
            let hexs = colors.map { HexObject(hex: $0.hex) }
            try realm.write {
                self.realm.add(hexs)
            }
        } catch {
            debugPrint(error)
        }
    }

    public var nextHex: HexEntity {
        if hexs.isEmpty {
            writeHexes()

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

//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/5.
//

import ClockShare
import CloudKit
import Foundation
import IdentifiedCollections
import OrderedCollections
import RealmSwift

public extension AppRealm {
    func writeRecord(_ entity: RecordEntity, addTo event: EventEntity) async {
        do {
            // 防止某些情况下会重复写入数据
            if await containsRecord(entity, of: event) { return }

            let realm = await realm
            guard let eventObject = realm.object(ofType: EventObject.self, forPrimaryKey: event._id) else { return }

            try await realm.asyncWrite {
                eventObject.deletedAt = nil

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
                eventObject.deletedAt = nil
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
                object.deletedAt = .now
            }
        } catch {
            debugPrint(error)
        }
    }

    func deleteRecord(by id: ObjectId) async {
        do {
            let realm = await realm
            guard let object = realm.object(ofType: RecordObject.self, forPrimaryKey: id) else { return }
            try await realm.asyncWrite {
                realm.delete(object)
            }
        } catch {
            debugPrint(error)
        }
    }

    func deleteRecord(by id: String) async throws {
        let objectId = try ObjectId(string: id)
        await deleteRecord(by: objectId)
    }

    func containsRecord(_ entity: RecordEntity, of event: EventEntity) async -> Bool {
        let realm = await realm
        return !realm.objects(RecordObject.self)
            .where {
                $0.creationMode == entity.creationMode &&
                    $0.notes == entity.notes &&
                    $0.startAt == entity.startAt &&
                    $0.endAt == entity.endAt &&
                    $0.events._id == event._id
            }
            .isEmpty
    }

    func getRecord(of entity: EventEntity, minEndAt: Date) async -> RecordEntity? {
        await getRecords {
            $0.events._id == entity._id &&
                $0.endAt > minEndAt
        }
        .first
    }

    func getRecords(where: (Query<RecordObject>) -> Query<Bool>, sortedBy areInIncreasingOrder: ((RecordEntity, RecordEntity) -> Bool)? = nil) async -> [RecordEntity] {
        await realm
            .objects(RecordObject.self)
            .where(`where`)
            .where { $0.deletedAt == nil }
            .map { RecordEntity(object: $0) }
            .sorted(by: areInIncreasingOrder ?? { $0.endAt > $1.endAt })
    }

    /// 和 getRecords 的主要区别是包含已删除的记录（deletedAt != nil）
    func findRecords(where: (Query<RecordObject>) -> Query<Bool>) async -> [RecordEntity] {
        await realm
            .objects(RecordObject.self)
            .where(`where`)
            .map { RecordEntity(object: $0) }
    }

    func containsRecord(where: (Query<RecordObject>) -> Query<Bool>) async -> Bool {
        await !getRecords(where: `where`).isEmpty
    }

    func sectionedRecords<Key: _Persistable & Hashable>(_ entity: EventEntity, by block: @escaping ((RecordObject) -> Key)) async -> OrderedDictionary<Key, [RecordEntity]> {
        var results = OrderedDictionary<Key, [RecordEntity]>()
        guard let eventObject = await realm.object(ofType: EventObject.self, forPrimaryKey: entity._id) else {
            return results
        }
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
            .where { $0.deletedAt == nil }
            .sorted(by: \.startAt, ascending: true)
            .map { RecordEntity(object: $0) }
    }
}

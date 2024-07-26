//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/24.
//

import CloudKit
import Foundation
import IceCream
import RealmSwift



extension CategoryEntity: EntityCKRecord {
    public static var ckRecordType: String { "CategoryEntity" }

    public init(ckRecord: CKRecord) throws {
        self._id = try ObjectId(string: ckRecord.recordID.recordName)
        if let data = ckRecord["hex"] as? Data {
            self.hex = try JSONDecoder().decode(HexEntity.self, from: data)
        }
        self.icon = ckRecord["icon"] as? String
        self.emoji = ckRecord["emoji"] as? String
        if let name = ckRecord["name"] as? String {
            self.name = name
        } else {
            throw EntityCKRecordError.`init`
        }
        self.events = []
        self.calendarIdentifier = ckRecord["calendarIdentifier"] as? String
        self.index = (ckRecord["index"] as? Int) ?? 0
        self.createdAt = (ckRecord["createdAt"] as? Date) ?? .init()
        self.deletedAt = ckRecord["deletedAt"] as? Date
        self.archivedAt = ckRecord["archivedAt"] as? Date
    }

    public func toCKRecord(in zone: CKRecordZone) -> CKRecord {
        let newRecordID = CKRecord.ID(recordName: _id.stringValue, zoneID: zone.zoneID)
        let newRecord = CKRecord(recordType: Self.ckRecordType, recordID: newRecordID)
        if let hex {
            newRecord["hex"] = try? JSONEncoder().encode(hex)
        }
        newRecord["emoji"] = emoji
        newRecord["icon"] = icon
        newRecord["name"] = name
        newRecord["calendarIdentifier"] = calendarIdentifier
        newRecord["index"] = index
        newRecord["createdAt"] = createdAt
        newRecord["deletedAt"] = deletedAt
        newRecord["archivedAt"] = archivedAt
        return newRecord
    }
}

public extension AppCloud {
    func writeCategory(_ entity: CategoryEntity) async {
        do {
            let newRecord = entity.toCKRecord(in: zone)
            let savedRecord = try await database.save(newRecord)
        } catch {
            debugPrint(error)
        }
    }
}

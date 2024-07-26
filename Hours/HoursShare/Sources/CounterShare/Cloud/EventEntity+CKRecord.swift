//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/24.
//

import CloudKit
import Foundation
import RealmSwift

extension EventEntity: EntityCKRecord {
    public static var ckRecordType: String { "EventEntity" }

    public init(ckRecord: CKRecord) throws {
        self._id = try ObjectId(string: ckRecord.recordID.recordName)
        if let data = ckRecord["hex"] as? Data {
            self.hex = try JSONDecoder().decode(HexEntity.self, from: data)
        }
        self.emoji = ckRecord["emoji"] as? String
        if let name = ckRecord["name"] as? String {
            self.name = name
        } else {
            throw EntityCKRecordError.`init`
        }
        self.isSystem = (ckRecord["isSystem"] as? Bool) ?? false
        self.items = []
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
        newRecord["name"] = name
        newRecord["isSystem"] = isSystem
        newRecord["milliseconds"] = milliseconds
        newRecord["createdAt"] = createdAt
        newRecord["deletedAt"] = deletedAt
        newRecord["archivedAt"] = archivedAt
        
        if let categoryID = category?.id {
            newRecord["categoryID"] = categoryID

            let categoryRecordID = CKRecord.ID(recordName: categoryID, zoneID: zone.zoneID)
            newRecord.parent = CKRecord.Reference(recordID: categoryRecordID, action: .deleteSelf)
        }
        return newRecord
    }

    public var categoryID: ObjectId? { category?._id }
}

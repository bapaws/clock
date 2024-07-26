//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/24.
//

import CloudKit
import Foundation
import RealmSwift

extension RecordEntity: EntityCKRecord {
    public static var ckRecordType: String { "RecordEntity" }

    public init(ckRecord: CKRecord) throws {
        self._id = try ObjectId(string: ckRecord.recordID.recordName)
        if let value = ckRecord["creationMode"] as? Int, let creationMode = RecordCreationMode(rawValue: value) {
            self.creationMode = creationMode
        } else {
            self.creationMode = .enter
        }
        if let endAt = ckRecord["endAt"] as? Date {
            self.endAt = endAt
        } else {
            throw EntityCKRecordError.`init`
        }
        if let startAt = ckRecord["startAt"] as? Date {
            self.startAt = startAt
        } else {
            throw EntityCKRecordError.`init`
        }

        self.notes = ckRecord["notes"] as? String
        self.deletedAt = ckRecord["deletedAt"] as? Date
        self.calendarEventIdentifier = ckRecord["calendarEventIdentifier"] as? String
        self.healthSampleUUIDString = ckRecord["healthSampleUUIDString"] as? String

        self.milliseconds = Int(startAt.distance(to: endAt) * 1000)
        self.time = milliseconds.time
    }

    public func toCKRecord(in zone: CKRecordZone) -> CKRecord {
        let newRecordID = CKRecord.ID(recordName: id, zoneID: zone.zoneID)
        let newRecord = CKRecord(recordType: Self.ckRecordType, recordID: newRecordID)
        newRecord["creationMode"] = creationMode.rawValue
        newRecord["startAt"] = startAt
        newRecord["endAt"] = endAt
        newRecord["notes"] = notes
        newRecord["deletedAt"] = deletedAt
        newRecord["calendarEventIdentifier"] = calendarEventIdentifier
        newRecord["healthSampleUUIDString"] = healthSampleUUIDString

        if let eventID = event?.id {
            newRecord["eventID"] = event?.id

            let eventRecordID = CKRecord.ID(recordName: eventID, zoneID: zone.zoneID)
            newRecord.parent = CKRecord.Reference(recordID: eventRecordID, action: .deleteSelf)
        }
        return newRecord
    }
}

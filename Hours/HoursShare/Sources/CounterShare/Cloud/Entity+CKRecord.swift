//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/24.
//

import CloudKit
import Foundation

public protocol EntityCKRecord: Codable {
//    var ckRecordName: String { get }
    static var ckRecordType: String { get }

    init(ckRecord: CKRecord) throws
    func toCKRecord(in zone: CKRecordZone) -> CKRecord
}

public enum EntityCKRecordError: Error {
    case `init`, to, notSupport
}

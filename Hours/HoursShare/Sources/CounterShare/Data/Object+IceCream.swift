//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/25.
//

import Foundation
import IceCream
import RealmSwift

extension CategoryObject: CKRecordConvertible, CKRecordRecoverable {
    public var isDeleted: Bool {
        deletedAt != nil
    }
}

extension EventObject: CKRecordConvertible, CKRecordRecoverable {
    public var isDeleted: Bool {
        deletedAt != nil
    }
}

extension RecordObject: CKRecordConvertible, CKRecordRecoverable {
    public var isDeleted: Bool {
        deletedAt != nil
    }
}

extension HexObject: CKRecordConvertible, CKRecordRecoverable {}

extension SchemeObject: CKRecordConvertible, CKRecordRecoverable {}

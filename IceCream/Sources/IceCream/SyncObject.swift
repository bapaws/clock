//
//  SyncSource.swift
//  IceCream
//
//  Created by David Collado on 1/5/18.
//

import CloudKit
import Foundation
import Realm
import RealmSwift

/// SyncObject is for each model you want to sync.
/// Logically,
/// 1. it takes care of the operations of CKRecordZone.
/// 2. it detects the changeSets of Realm Database and directly talks to it.
/// 3. it hands over to SyncEngine so that it can talk to CloudKit.

public final class SyncObject<T, U, V, W> where T: Object & CKRecordConvertible & CKRecordRecoverable, U: Object, V: Object, W: Object {
    /// Notifications are delivered as long as a reference is held to the returned notification token. We should keep a strong reference to this token on the class registering for updates, as notifications are automatically unregistered when the notification token is deallocated.
    /// For more, reference is here: https://realm.io/docs/swift/latest/#notifications
    private var notificationToken: NotificationToken?

    public var pipeToEngine: ((_ recordsToStore: [CKRecord], _ recordIDsToDelete: [CKRecord.ID]) -> ())?

    public let realmConfiguration: Realm.Configuration

    private let pendingUTypeRelationshipsWorker = PendingRelationshipsWorker<U>()
    private let pendingVTypeRelationshipsWorker = PendingRelationshipsWorker<V>()
    private let pendingWTypeRelationshipsWorker = PendingRelationshipsWorker<W>()

    public init(
        realmConfiguration: Realm.Configuration = .defaultConfiguration,
        type: T.Type,
        uListElementType: U.Type? = nil,
        vListElementType: V.Type? = nil,
        wListElementType: W.Type? = nil
    ) {
        self.realmConfiguration = realmConfiguration
    }
}

// MARK: - Zone information

extension SyncObject: Syncable {
    public var recordType: String {
        return T.recordType
    }

    public var zoneID: CKRecordZone.ID {
        return T.zoneID
    }

    public var zoneChangesToken: CKServerChangeToken? {
        get {
            /// For the very first time when launching, the token will be nil and the server will be giving everything on the Cloud to client
            /// In other situation just get the unarchive the data object
            guard let tokenData = UserDefaults.standard.object(forKey: T.className() + IceCreamKey.zoneChangesTokenKey.value) as? Data else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? CKServerChangeToken
        }
        set {
            guard let n = newValue else {
                UserDefaults.standard.removeObject(forKey: T.className() + IceCreamKey.zoneChangesTokenKey.value)
                return
            }
            let data = NSKeyedArchiver.archivedData(withRootObject: n)
            UserDefaults.standard.set(data, forKey: T.className() + IceCreamKey.zoneChangesTokenKey.value)
        }
    }

    public var isCustomZoneCreated: Bool {
        get {
            guard let flag = UserDefaults.standard.object(forKey: T.className() + IceCreamKey.hasCustomZoneCreatedKey.value) as? Bool else { return false }
            return flag
        }
        set {
            UserDefaults.standard.set(newValue, forKey: T.className() + IceCreamKey.hasCustomZoneCreatedKey.value)
        }
    }

    public func add(record: CKRecord) {
        BackgroundWorker.shared.start { [weak self] in
            guard let self, let realm = try? Realm(configuration: self.realmConfiguration) else { return }

            guard let object = T.parseFromRecord(
                record: record,
                realm: realm,
                notificationToken: self.notificationToken,
                pendingUTypeRelationshipsWorker: self.pendingUTypeRelationshipsWorker,
                pendingVTypeRelationshipsWorker: self.pendingVTypeRelationshipsWorker,
                pendingWTypeRelationshipsWorker: self.pendingWTypeRelationshipsWorker
            ) else {
                print("There is something wrong with the converson from cloud record to local object")
                return
            }
            self.pendingUTypeRelationshipsWorker.realm = realm
            self.pendingVTypeRelationshipsWorker.realm = realm
            self.pendingWTypeRelationshipsWorker.realm = realm

            /// If your model class includes a primary key, you can have Realm intelligently update or add objects based off of their primary key values using Realm().add(_:update:).
            /// https://realm.io/docs/swift/latest/#objects-with-primary-keys
            realm.beginWrite()
            realm.add(object, update: .modified)
            if let token = self.notificationToken {
                try? realm.commitWrite(withoutNotifying: [token])
            } else {
                try? realm.commitWrite()
            }
        }
    }

    public func delete(recordID: CKRecord.ID) {
        BackgroundWorker.shared.start { [weak self] in
            guard let self, let realm = try? Realm(configuration: self.realmConfiguration) else { return }

            guard let object = realm.object(ofType: T.self, forPrimaryKey: T.primaryKeyForRecordID(recordID: recordID)) else {
                // Not found in local realm database
                return
            }
            CreamAsset.deleteCreamAssetFile(with: recordID.recordName)
            realm.beginWrite()
            realm.delete(object)
            if let token = self.notificationToken {
                try? realm.commitWrite(withoutNotifying: [token])
            } else {
                try? realm.commitWrite()
            }
        }
    }

    /// When you commit a write transaction to a Realm, all other instances of that Realm will be notified, and be updated automatically.
    /// For more: https://realm.io/docs/swift/latest/#writes
    public func registerLocalDatabase() {
        BackgroundWorker.shared.start { [weak self] in
            guard let self, self.notificationToken == nil else { return }

            guard let realm = try? Realm(configuration: self.realmConfiguration) else { return }

            self.notificationToken = realm.objects(T.self).observe { [weak self] changes in
                guard let self = self else { return }
                switch changes {
                case .initial:
                    break
                case .update(let collection, _, let insertions, let modifications):
                    let recordsToStore = (insertions + modifications).filter { $0 < collection.count }.map { collection[$0] }.filter { !$0.isDeleted }.map { $0.record }
                    let recordIDsToDelete = modifications.filter { $0 < collection.count }.map { collection[$0] }.filter { $0.isDeleted }.map { $0.recordID }

                    guard recordsToStore.count > 0 || recordIDsToDelete.count > 0 else { return }
                    self.pipeToEngine?(recordsToStore, recordIDsToDelete)
                case .error:
                    break
                }
            }
        }
    }

    public func unregisterLocalDatabase() {
        BackgroundWorker.shared.start { [weak self] in
            self?.notificationToken?.invalidate()
            self?.notificationToken = nil
        }
    }

    public func resolvePendingRelationships() {
        pendingUTypeRelationshipsWorker.resolvePendingListElements()
        pendingVTypeRelationshipsWorker.resolvePendingListElements()
        pendingWTypeRelationshipsWorker.resolvePendingListElements()

        BackgroundWorker.shared.start { [weak self] in
            /// 原因：由于 iCloud 数据返回顺序可能不一定，关联的属性对象没有提前返回时，无法获取数据导致数据为空，此时进行数据修复操作
            /// 创建 Realm 对象用于数据修复
            guard let self, let realm = try? Realm(configuration: self.realmConfiguration) else { return }

            realm.beginWrite()
            let relationships = realm.objects(PendingRelationshipObject.self)
            for relationship in relationships {
                // 获取属性的动态对象
                guard let propertyID = try? ObjectId(string: relationship.propertyID), let propertyDynamicObject = realm.dynamicObject(ofType: relationship.propertyObjectClassName, forPrimaryKey: propertyID) else {
                    continue
                }
                // 获取对象
                guard let objectID = try? ObjectId(string: relationship.objectID), let object = realm.dynamicObject(ofType: relationship.objectClassName, forPrimaryKey: objectID) else {
                    continue
                }
                // 写入数据
                object[relationship.propertyName] = propertyDynamicObject
                // 删除已经写入的关系数据
                realm.delete(relationship)
            }
            if let token = self.notificationToken {
                try? realm.commitWrite(withoutNotifying: [token])
            } else {
                try? realm.commitWrite()
            }
        }
    }

    public func cleanUp() {
        BackgroundWorker.shared.start { [weak self] in
            guard let self, let realm = try? Realm(configuration: self.realmConfiguration) else { return }
            let objects = realm.objects(T.self).filter { $0.isDeleted }

            var tokens: [NotificationToken] = []
            self.notificationToken.flatMap { tokens = [$0] }

            realm.beginWrite()
            objects.forEach { realm.delete($0) }

            try? realm.commitWrite(withoutNotifying: tokens)
        }
    }

    public func pushLocalObjectsToCloudKit() {
        BackgroundWorker.shared.start { [weak self] in
            guard let self, let realm = try? Realm(configuration: self.realmConfiguration) else { return }

            let recordsToStore: [CKRecord] = realm.objects(T.self).filter { !$0.isDeleted }.map { $0.record }
            self.pipeToEngine?(recordsToStore, [])
        }
    }
}

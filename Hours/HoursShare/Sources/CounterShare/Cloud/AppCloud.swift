//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/24.
//

import CloudKit
import Combine
import Foundation
import RealmSwift

public class AppCloud: ObservableObject {
    public static let shared = AppCloud()

    // MARK: CloudKit Properties

    /// The CloudKit container we'll use.
    lazy var container = CKContainer(identifier: "iCloud.com.bapaws.hours")
    /// For this sample we use the iCloud user's private database.
    lazy var database = container.privateCloudDatabase
    /// We use a custom record zone to support fetching only changed records.
    let zone = CKRecordZone(zoneName: "Hours")
    /// Each subscription requires a unique ID.
    let subscriptionID = "changes-subscription-id"
    /// We use a change token to inform the server of the last time we had the most recent remote data.
    private(set) var lastChangeToken: CKServerChangeToken?

    // MARK: Subscribers

    private var subscribers: [AnyCancellable] = []

    private var token: NotificationToken?

    /// Loads any stored cache and change token, and creates custom zone and subscription as needed.
    func initialize() async throws {
        loadLastChangeToken()

        try await createZoneIfNeeded()
        try await createSubscriptionIfNeeded()
    }

//    func observeRealm() async {
//        let realm = await AppRealm.shared.realm
//        token = realm.observe { notification, realm in
//            switch notification {
//            case .didChange:
//            case .refreshRequired:
//
//            }
//        }
//    }
}

public extension AppCloud {
    /// Using the last known change token, retrieve changes on the zone since the last time we pulled from iCloud.
    /// If `lastChangeToken` is `nil`, all records will be retrieved.
    func fetchLatestChanges() async throws {
        /// `recordZoneChanges` can return multiple consecutive changesets before completing, so
        /// we use a loop to process multiple results if needed, indicated by the `moreComing` flag.
        var awaitingChanges = true

        while awaitingChanges {
            /// Fetch changeset for the last known change token.
            let changes = try await database.recordZoneChanges(inZoneWith: zone.zoneID, since: lastChangeToken)

            /// Convert changes to `CKRecord` objects and deleted IDs.
            let changedRecords = changes.modificationResultsByID.compactMapValues { try? $0.get().record }

            /// Handle changes objects and deleted IDs.
            try await handleChangedRecords(changedRecords)
            try await handleDeletedRecords(changes.deletions)

            /// Save our new change token representing this point in time.
            saveChangeToken(changes.changeToken)

            /// If there are more changes coming, we need to repeat this process with the new token.
            /// This is indicated by the returned changeset `moreComing` flag.
            awaitingChanges = changes.moreComing
        }
    }

    private func handleChangedRecords(_ changedRecords: [CKRecord.ID: CKRecord]) async throws {
        for (_, record) in changedRecords {
            switch record.recordType {
            case CategoryEntity.ckRecordType:
                try await AppRealm.shared.createOrUpdateCategory(by: record)

            case EventEntity.ckRecordType:
                try await AppRealm.shared.createOrUpdateEvent(by: record)

            case RecordEntity.ckRecordType:
                try await AppRealm.shared.createOrUpdateRecord(by: record)

            default:
                throw EntityCKRecordError.notSupport
            }
        }
    }

    private func handleDeletedRecords(_ deletions: [CKDatabase.RecordZoneChange.Deletion]) async throws {
        for deletion in deletions {
            let id = deletion.recordID.recordName
            switch deletion.recordType {
            case CategoryEntity.ckRecordType:
                try await AppRealm.shared.deleteCategory(by: id)

            case EventEntity.ckRecordType:
                try await AppRealm.shared.deleteEvent(by: id)

            case RecordEntity.ckRecordType:
                try await AppRealm.shared.deleteRecord(by: id)

            default:
                throw EntityCKRecordError.notSupport
            }
        }
    }
}

// MARK: - Local Caching

public extension AppCloud {
    private func loadLastChangeToken() {
        guard let data = UserDefaults.standard.data(forKey: "lastChangeToken"),
              let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CKServerChangeToken.self, from: data)
        else {
            return
        }

        lastChangeToken = token
    }

    private func saveChangeToken(_ token: CKServerChangeToken) {
        let tokenData = try! NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)

        lastChangeToken = token
        UserDefaults.standard.set(tokenData, forKey: "lastChangeToken")
    }
}

// MARK: - CloudKit Initialization Helpers

public extension AppCloud {
    /// Creates the custom zone defined by the `zone` property if needed.
    func createZoneIfNeeded() async throws {
        // Avoid the operation if this has already been done.
        guard !UserDefaults.standard.bool(forKey: "isZoneCreated") else {
            return
        }

        do {
            _ = try await database.modifyRecordZones(saving: [zone], deleting: [])
        } catch {
            print("ERROR: Failed to create custom zone: \(error.localizedDescription)")
            throw error
        }

        UserDefaults.standard.setValue(true, forKey: "isZoneCreated")
    }

    /// Creates a subscription if needed that tracks changes to our custom zone.
    func createSubscriptionIfNeeded() async throws {
        guard !UserDefaults.standard.bool(forKey: "isSubscribed") else {
            return
        }

        // First check if the subscription has already been created.
        // If a subscription is returned, we don't need to create one.
        let foundSubscription = try? await database.subscription(for: subscriptionID)
        guard foundSubscription == nil else {
            UserDefaults.standard.setValue(true, forKey: "isSubscribed")
            return
        }

        // No subscription created yet, so create one here, reporting and passing along any errors.
        let subscription = CKRecordZoneSubscription(zoneID: zone.zoneID, subscriptionID: subscriptionID)
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo

        _ = try await database.modifySubscriptions(saving: [subscription], deleting: [])
        UserDefaults.standard.setValue(true, forKey: "isSubscribed")
    }
}

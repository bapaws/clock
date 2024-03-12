//
//  DBManager.swift
//
//
//  Created by 张敏超 on 2024/3/6.
//

import Foundation
import RealmSwift
import SwiftDate

public class DBManager: ObservableObject {
    public static let `default` = DBManager()

    #if DEBUG
        public let config = Realm.Configuration(schemaVersion: 0, deleteRealmIfMigrationNeeded: true)
    #else
        public let config = Realm.Configuration(schemaVersion: 0)
    #endif

    public private(set) var realm: Realm

    private var hexIndex = 0
    public var hexs: Results<HexObject> {
        didSet {
            hexIndex = events.count % hexs.count
        }
    }

    // MARK: Categorys

    public var categorys: Results<CategoryObject>

    // MARK: Events

    private var eventsNotificationToken: NotificationToken?
    public var events: Results<EventObject>
    /// 当前所有事件中，最小的创建时间
    /// 用于统计时，获取使用 app 的最早时间，用于限制时间筛选
    public private(set) var minCreateAt: Date = .init()
    /// 统计里至今记录的所有时间
    public private(set) var totalMilliseconds: Int = 0

    // MARK: Records
    public var records: Results<RecordObject>

    public var schemaVersion: UInt64 {
        config.schemaVersion
    }

    public var nextHex: HexObject {
        hexs[hexIndex]
    }

    private init() {
        let realm = try! Realm(configuration: config)
        self.realm = realm

        hexs = realm.objects(HexObject.self)
        categorys = realm.objects(CategoryObject.self)

        records = realm.objects(RecordObject.self)

        events = realm.objects(EventObject.self)
        eventsNotificationToken = events.observe { [weak self] change in
            switch change {
            case .initial(let collectionType):
                print(collectionType)
                self?.didSetEvents()
            case .update(let collectionType, _, _, _):
                print(collectionType)
                self?.didSetEvents()
            case .error(let error):
                print("An error occurred: \(error)")
            }
        }
    }

    private func didSetEvents() {
        var milliseconds = 0
        for task in events {
            milliseconds += task.milliseconds
        }
        totalMilliseconds = milliseconds

        if let minCreateAt = events.min(of: \.createdAt) {
            self.minCreateAt = minCreateAt
        } else {
            minCreateAt = .init()
        }

        if hexs.count != 0 {
            hexIndex = events.count % hexs.count
        }
    }
}


// MARK: Records
public extension DBManager {

    func getRecords(for date: Date) -> Results<RecordObject> {
        let startOfDay = date.dateAtStartOf(.day)
        let tomorrow = date.dateAt(.tomorrowAtStart)
        let predicate = NSPredicate(format: "startAt >= %@ AND startAt < %@", startOfDay as NSDate, tomorrow as NSDate)
        return realm.objects(RecordObject.self).filter(predicate)
    }

    func getRecordEndAt(for date: Date) -> Date? {
        let startOfDay = date.dateAtStartOf(.day)
        let tomorrow = date.dateAt(.tomorrowAtStart)
        let predicate = NSPredicate(format: "startAt >= %@ AND startAt < %@", startOfDay as NSDate, tomorrow as NSDate)
        return realm.objects(RecordObject.self).filter(predicate).sorted(byKeyPath: "startAt", ascending: false).last?.endAt
    }
}

//
//  DBManager.swift
//
//
//  Created by 张敏超 on 2024/3/6.
//

import ClockShare
import Foundation
import RealmSwift
import SwiftDate

public class DBManager: ObservableObject {
    public static let `default` = DBManager()

    public let config = Realm.Configuration(schemaVersion: 6)

    public private(set) var realm: Realm

    private var hexIndex = 0 {
        didSet { Storage.default.hexIndex = hexIndex }
    }

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
        let hex = hexs[hexIndex % hexs.count]
        hexIndex += 1
        return hex
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
            case .update(let collectionType, _, let insertions, _):
                print(collectionType)
                self?.didSetEvents()
            case .error(let error):
                print("An error occurred: \(error)")
            }
        }

        // 设置颜色的 Index
        setupHexIndex()
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
    }

    private func setupHexIndex() {
        if let index = Storage.default.hexIndex {
            hexIndex = index
        } else {
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
        return realm.objects(RecordObject.self).filter(predicate).sorted(by: \.endAt, ascending: false)
    }

    func getRecordEndAt(for date: Date) -> Date? {
        let startOfDay = date.dateAtStartOf(.day)
        let tomorrow = date.dateAt(.tomorrowAtStart)
        let predicate = NSPredicate(format: "startAt >= %@ AND startAt < %@", startOfDay as NSDate, tomorrow as NSDate)
        return realm.objects(RecordObject.self).filter(predicate).sorted(byKeyPath: "endAt", ascending: true).last?.endAt
    }
}

// MARK: Statistics

public extension DBManager {
    func getDailyEvents(for date: Date) -> Results<EventObject> {
        let startOfDay = date.dateAtStartOf(.day)
        let tomorrow = date.dateAt(.tomorrowAtStart)
        let predicate = NSPredicate(format: "ANY items.startAt >= %@ AND ANY items.startAt < %@", startOfDay as NSDate, tomorrow as NSDate)
        return realm.objects(EventObject.self).filter(predicate)
    }

    func getDailyRecords(for event: EventObject, in results: Results<RecordObject>) -> Results<RecordObject> {
        results.where { $0.event == event }
    }

    func getDailyRecords(for category: CategoryObject, in results: Results<RecordObject>) -> Results<RecordObject> {
        results.where { $0.event.categorys.contains(category) }
    }
}

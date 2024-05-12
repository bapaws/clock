//
//  RecordObject.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/4.
//

import Foundation
import RealmSwift
import SwiftDate

// MARK: Help

public typealias TimeLength = (day: Int, hour: Int, minute: Int, second: Int)

public extension Int {
    // convert Millisecond to time tuple
    var time: TimeLength {
        let seconds: Int = .init((Double(self) / 1000).rounded())
        return (seconds / 3600 / 24, seconds / 3600 % 24, seconds / 60 % 60, seconds % 60)
    }
}

// MARK: - RecordObject

public enum RecordCreationMode: Int, PersistableEnum, Codable {
    case pomodoro, timer, enter, shortcut
}

public class RecordObject: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId

    /// 任务计时类型：倒计时 or 正计时
    @Persisted public var creationMode: RecordCreationMode
    /// 持续时间
    @Persisted public private(set) var milliseconds: Int {
        didSet {
            time = milliseconds.time
        }
    }

    // 开始时间
    @Persisted(indexed: true) public var startAt: Date
    /// 结束时间
    @Persisted public var endAt: Date {
        didSet {
            milliseconds = Int(startAt.distance(to: endAt) * 1000)
        }
    }

    @Persisted public var notes: String?

    @Persisted(originProperty: "items") public var events: LinkingObjects<EventObject>
    public var event: EventObject? { events.first }

    /// 同步到苹果系统日历事件的 eventIdentifier
    @Persisted public var calendarEventIdentifier: String?

    public lazy var time: TimeLength = milliseconds.time
    public var hours: Int { time.hour }
    public var minutes: Int { time.minute }
    public var seconds: Int { time.second }

    override public init() {
        super.init()
    }

    public init(creationMode: RecordCreationMode, startAt: Date, milliseconds: Int) {
        super.init()

        self.creationMode = creationMode
        self.startAt = startAt
        self.milliseconds = milliseconds
        endAt = startAt.addingTimeInterval(TimeInterval(milliseconds) / 1000)
    }

    public init(creationMode: RecordCreationMode, startAt: Date, endAt: Date) {
        super.init()

        self.creationMode = creationMode
        self.startAt = startAt
        self.endAt = endAt
        milliseconds = Int(startAt.distance(to: endAt) * 1000)
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case creationMode
        case milliseconds
        case startAt
    }

    public required init(from decoder: any Decoder) throws {
        super.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        creationMode = try container.decode(RecordCreationMode.self, forKey: .creationMode)
        milliseconds = try container.decode(Int.self, forKey: .milliseconds)
        startAt = try container.decode(Date.self, forKey: .startAt)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(creationMode, forKey: .creationMode)
        try container.encode(milliseconds, forKey: .milliseconds)
        try container.encode(startAt, forKey: .startAt)
    }
}

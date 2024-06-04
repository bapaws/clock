//
//  RecordObject.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/4.
//

import Foundation
import RealmSwift
import SwiftDate

// MARK: - RecordObject

public enum RecordCreationMode: Int, PersistableEnum, Codable {
    case pomodoro, timer, enter, shortcut, health
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

    @Persisted public var healthSampleUUIDString: String?

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
        self.endAt = startAt.addingTimeInterval(TimeInterval(milliseconds) / 1000)
    }

    public init(creationMode: RecordCreationMode, startAt: Date, endAt: Date) {
        super.init()

        self.creationMode = creationMode
        self.startAt = startAt
        self.endAt = endAt
        self.milliseconds = Int(startAt.distance(to: endAt) * 1000)
    }

    public init(creationMode: RecordCreationMode, startAt: Date, milliseconds: Int, endAt: Date) {
        super.init()

        self.creationMode = creationMode
        self.startAt = startAt
        self.milliseconds = milliseconds
        self.endAt = endAt
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
        self.creationMode = try container.decode(RecordCreationMode.self, forKey: .creationMode)
        self.milliseconds = try container.decode(Int.self, forKey: .milliseconds)
        self.startAt = try container.decode(Date.self, forKey: .startAt)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(creationMode, forKey: .creationMode)
        try container.encode(milliseconds, forKey: .milliseconds)
        try container.encode(startAt, forKey: .startAt)
    }
}

// MARK: Entity

public struct RecordEntity: Entity {
    public var _id: ObjectId = .generate()

    /// 任务计时类型：倒计时 or 正计时
    public var creationMode: RecordCreationMode
    /// 持续时间
    public private(set) var milliseconds: Int {
        didSet {
            time = milliseconds.time
        }
    }

    // 开始时间
    public var startAt: Date
    /// 结束时间
    public var endAt: Date {
        didSet {
            milliseconds = Int(startAt.distance(to: endAt) * 1000)
        }
    }

    public var notes: String?

    public var event: EventEntity?

    /// 同步到苹果系统日历事件的 eventIdentifier
    public var calendarEventIdentifier: String?

    public var healthSampleUUIDString: String?

    public private(set) var time: TimeLength

    public init(object: RecordObject, isLinkedObject: Bool = false) {
        self.creationMode = object.creationMode
        self.milliseconds = object.milliseconds
        self.startAt = object.startAt
        self.endAt = object.endAt
        self.notes = object.notes
        if let event = object.event {
            self.event = EventEntity(object: event, isLinkedObject: true)
        }
        self.calendarEventIdentifier = object.calendarEventIdentifier
        self.healthSampleUUIDString = object.healthSampleUUIDString

        self.time = milliseconds.time
    }

    public init(creationMode: RecordCreationMode, startAt: Date, milliseconds: Int) {
        self.creationMode = creationMode
        self.startAt = startAt
        self.milliseconds = milliseconds
        self.endAt = startAt.addingTimeInterval(TimeInterval(milliseconds) / 1000)

        self.time = milliseconds.time
    }

    public init(creationMode: RecordCreationMode, startAt: Date, endAt: Date) {
        self.creationMode = creationMode
        self.startAt = startAt
        self.endAt = endAt
        self.milliseconds = Int(startAt.distance(to: endAt) * 1000)

        self.time = milliseconds.time
    }

    public init(creationMode: RecordCreationMode, startAt: Date, milliseconds: Int, endAt: Date) {
        self.creationMode = creationMode
        self.startAt = startAt
        self.milliseconds = milliseconds
        self.endAt = endAt

        self.time = milliseconds.time
    }

    public static func random(count: Int) -> [RecordEntity] {
        var entities = [Self]()
        for _ in 0 ..< count {
            var entity = RecordEntity(creationMode: .enter, startAt: Date(), milliseconds: Int.random(in: 60 * 1000 ... 5 * 60 * 60 * 1000))
            entity.event = EventEntity.random()
            entities.append(entity)
        }
        return entities
    }
}

public extension RecordEntity {
    var hours: Int { time.hour }
    var minutes: Int { time.minute }
    var seconds: Int { time.second }
}

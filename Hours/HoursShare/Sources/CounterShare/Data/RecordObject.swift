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
    case pomodoro, timer, enter, shortcut, health, calendar
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

    /// 删除时间
    @Persisted public var deletedAt: Date?

    @Persisted(originProperty: "items") public var events: LinkingObjects<EventObject>
    public var event: EventObject? { events.first }
    /// 为了排查问题方便，在存储中加入了关系 id
    /// 这里保存了 eventID
    @Persisted public var linkingObjectID: String?

    /// 同步到苹果系统日历事件的 eventIdentifier
    @Persisted public var calendarEventIdentifier: String?

    @Persisted public var healthSampleUUIDString: String?
    @Persisted public var sleepSampleUUIDStrings: RealmSwift.MutableSet<String>

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
    public var _id: ObjectId

    /// 任务计时类型：倒计时 or 正计时
    public var creationMode: RecordCreationMode
    /// 持续时间
    public var milliseconds: Int {
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

    /// 删除时间
    public var deletedAt: Date?

    public var event: EventEntity? {
        didSet { linkingObjectID = event?.id }
    }

    private var linkingObjectID: String?

    /// 同步到苹果系统日历事件的 eventIdentifier
    public var calendarEventIdentifier: String?

    public var healthSampleUUIDString: String?

    /// Realm 版本 16
    public var healthSampleUUIDStrings: Set<String> = []
    public var sleepSampleUUIDStrings: Set<String> = []

    public var time: TimeLength

    public init(creationMode: RecordCreationMode, startAt: Date, milliseconds: Int) {
        self._id = .generate()
        self.creationMode = creationMode
        self.startAt = startAt
        self.milliseconds = milliseconds
        self.endAt = startAt.addingTimeInterval(TimeInterval(milliseconds) / 1000)

        self.time = milliseconds.time
    }

    public init(creationMode: RecordCreationMode, startAt: Date, endAt: Date) {
        self._id = .generate()
        self.creationMode = creationMode
        self.startAt = startAt
        self.endAt = endAt
        self.milliseconds = Int(startAt.distance(to: endAt) * 1000)

        self.time = milliseconds.time
    }

    public init(creationMode: RecordCreationMode, startAt: Date, milliseconds: Int, endAt: Date) {
        self._id = .generate()
        self.creationMode = creationMode
        self.startAt = startAt
        self.milliseconds = milliseconds
        self.endAt = endAt

        self.time = milliseconds.time
    }

    // MARK: Entity

    public init(object: RecordObject, isLinkedObject: Bool = false) {
        self._id = object._id
        self.creationMode = object.creationMode
        self.milliseconds = object.milliseconds
        self.startAt = object.startAt
        self.endAt = object.endAt
        self.notes = object.notes
        self.deletedAt = object.deletedAt
        if let event = object.event {
            self.event = EventEntity(object: event, isLinkedObject: true)
            self.linkingObjectID = event._id.stringValue
        }
        self.calendarEventIdentifier = object.calendarEventIdentifier
        self.healthSampleUUIDString = object.healthSampleUUIDString
        self.sleepSampleUUIDStrings = Set(object.sleepSampleUUIDStrings.map { $0 })

        self.time = milliseconds.time
    }

    public func toObject() -> RecordObject {
        let object = RecordObject()
        object._id = _id
        object.creationMode = creationMode
        // 设置 endAt 时会自动设置，目前 milliseconds 和 endAt 是关联的
//        object.milliseconds = milliseconds
        object.startAt = startAt
        object.endAt = endAt
        object.notes = notes
        object.deletedAt = deletedAt
        object.calendarEventIdentifier = calendarEventIdentifier
        object.healthSampleUUIDString = healthSampleUUIDString
        object.sleepSampleUUIDStrings.insert(objectsIn: sleepSampleUUIDStrings)
        object.linkingObjectID = linkingObjectID
        return object
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

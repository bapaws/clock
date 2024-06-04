//
//  Task.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/8.
//

import Foundation
import RealmSwift

public class EventObject: Object, ObjectKeyIdentifiable, Codable, HexObjectColors, @unchecked Sendable {
    @Persisted(primaryKey: true) public var _id: ObjectId
    /// 名称
    @Persisted public var name: String
    /// 标签
    @Persisted(originProperty: "events") public var categorys: LinkingObjects<CategoryObject>
    /// Emoji
    @Persisted public var emoji: String?
    /// 颜色
    @Persisted public var hex: HexObject?
    /// 包含的执行对象
    @Persisted public var items: List<RecordObject> {
        didSet {
            self.milliseconds = self.items.sum(of: \.milliseconds)
        }
    }

    /// 是否可以删除
    @Persisted public var isSystem: Bool = false

    /// 创建时间
    @Persisted public var createdAt: Date = .init()
    /// 删除时间
    @Persisted public var deletedAt: Date?
    /// 归档时间
    @Persisted public var archivedAt: Date?

    /// 事件的分类
    public var category: CategoryObject { self.categorys[0] }

    public lazy var milliseconds: Int = items.sum(of: \.milliseconds)

    public lazy var time: TimeLength = milliseconds.time
    public var hours: Int { self.time.hour }
    public var minutes: Int { self.time.minute }
    public var seconds: Int { self.time.second }

    public var title: String {
        if let emoji = emoji {
            return emoji + " " + self.name
        }
        return self.name
    }

    override public init() {
        super.init()
    }

    public init(
        emoji: String? = nil,
        name: String,
        hex: HexObject? = nil,
        items: List<RecordObject> = List<RecordObject>(),
        isSystem: Bool = false
    ) {
        super.init()
        self._id = ObjectId.generate()
        self.emoji = emoji
        self.name = name
        self.hex = hex
        self.items = items
        self.createdAt = .init()
        self.isSystem = isSystem
    }

    // MARK: Codable

    enum CodingKeys: CodingKey {
        case _id
        case name
        case emoji
        case hex
        case items
        case createdAt
    }

    public required init(from decoder: any Decoder) throws {
        super.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try ObjectId(string: container.decode(String.self, forKey: ._id))
        self.name = try container.decode(String.self, forKey: .name)
        self.emoji = try container.decodeIfPresent(String.self, forKey: .emoji)
        self.hex = try container.decodeIfPresent(HexObject.self, forKey: .hex)
        self.items = try container.decodeIfPresent(List<RecordObject>.self, forKey: .items) ?? List<RecordObject>()
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self._id.stringValue, forKey: ._id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.emoji, forKey: .emoji)
        try container.encode(self.hex, forKey: .hex)
        try container.encode(self.items, forKey: .items)
        try container.encode(self.createdAt, forKey: .createdAt)
    }
}

// MARK: EventEntity

public struct EventEntity: Entity, HexEntityColors {
    public var _id: ObjectId = .generate()
    /// 名称
    public var name: String

    /// Emoji
    public var emoji: String?
    /// 颜色
    public var hex: HexEntity?
    /// 包含的执行对象
    public var items: [RecordEntity] {
        didSet { self.milliseconds = self.items.reduce(0) { $0 + $1.milliseconds } }
    }

    /// 是否可以删除
    public var isSystem: Bool = false

    /// 创建时间
    public var createdAt: Date = .init()
    /// 删除时间
    public var deletedAt: Date?
    /// 归档时间
    public var archivedAt: Date?

    /// 事件的分类
    public var category: CategoryEntity?

    public var milliseconds: Int = 0
    public var time: TimeLength = .zero

    public init(
        emoji: String? = nil,
        name: String,
        hex: HexEntity? = nil,
        items: [RecordEntity] = [],
        isSystem: Bool = false
    ) {
        self.emoji = emoji
        self.name = name
        self.hex = hex
        self.items = items
        self.createdAt = .init()
        self.isSystem = isSystem
    }

    public init(object: EventObject, isLinkedObject: Bool = false) {
        self._id = object._id
        self.emoji = object.emoji
        self.name = object.name
        if let hex = object.hex {
            self.hex = HexEntity(object: hex)
        }
        if isLinkedObject {
            self.items = []
        } else {
            self.items = object.items.map { RecordEntity(object: $0, isLinkedObject: true) }
        }
        self.createdAt = object.createdAt
        self.isSystem = object.isSystem
        self.deletedAt = object.deletedAt
        self.archivedAt = object.archivedAt
        self.category = CategoryEntity(object: object.category, isLinkedObject: true)

        self.milliseconds = object.milliseconds
        self.time = object.time
    }

    public static func random(count: Int) -> [EventEntity] {
        var entities = [Self]()
        for index in 0 ..< count {
            var entity = EventEntity(emoji: randomEmoji(), name: "\(index)", hex: HexEntity.random())
            entity.category = CategoryEntity.random()
            entities.append(entity)
        }
        return entities
    }
}

public extension EventEntity {
    var hours: Int { self.time.hour }
    var minutes: Int { self.time.minute }
    var seconds: Int { self.time.second }

    var title: String {
        if let emoji = emoji {
            return emoji + " " + self.name
        }
        return self.name
    }
}

//
//  Task.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/8.
//

import Foundation
import RealmSwift

public class EventObject: Object, ObjectKeyIdentifiable, Codable, HexColors {
    @Persisted(primaryKey: true) var _id: ObjectId
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

    /// 创建时间
    @Persisted public var createdAt: Date = .init()
    /// 是否可以删除
    @Persisted public var isSystem: Bool = false

    /// 事件的分类
    public var category: CategoryObject? { self.categorys.first }

    public lazy var milliseconds: Int = items.sum(of: \.milliseconds)

    public lazy var time: TimeLength = milliseconds.time
    public var hours: Int { self.time.hour }
    public var minutes: Int { self.time.minute }
    public var seconds: Int { self.time.second }

    public var title: String {
        if let emoji = emoji {
            return emoji + " " + name
        }
        return name
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
        self.name = try container.decode(String.self, forKey: .name)
        self.emoji = try container.decodeIfPresent(String.self, forKey: .emoji)
        self.hex = try container.decodeIfPresent(HexObject.self, forKey: .hex)
        self.items = try container.decodeIfPresent(List<RecordObject>.self, forKey: .items) ?? List<RecordObject>()
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self._id, forKey: ._id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.emoji, forKey: .emoji)
        try container.encode(self.hex, forKey: .hex)
        try container.encode(self.items, forKey: .items)
        try container.encode(self.createdAt, forKey: .createdAt)
    }
}

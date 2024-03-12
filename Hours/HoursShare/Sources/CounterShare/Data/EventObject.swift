//
//  Task.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/8.
//

import Foundation
import RealmSwift

public class EventObject: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId
    /// 名称
    @Persisted public var name: String
    /// 标签
    @Persisted public var category: CategoryObject?
    /// Emoji
    @Persisted public var emoji: String?
    /// 颜色
    @Persisted public var hex: HexObject?
    /// 包含的执行对象
    @Persisted public var items: List<RecordObject> {
        didSet {
            milliseconds = items.sum(of: \.milliseconds)
        }
    }

    // 创建时间
    @Persisted public var createdAt: Date = .init()

    public lazy var milliseconds: Int = items.sum(of: \.milliseconds)

    public lazy var time: (hour: Int, minute: Int, second: Int) = milliseconds.time
    public var hours: Int { time.hour }
    public var minutes: Int { time.minute }
    public var seconds: Int { time.second }

    override public init() {
        super.init()
    }

    public init(emoji: String? = nil, name: String, category: CategoryObject? = nil, hex: HexObject? = nil, items: List<RecordObject> = List<RecordObject>()) {
        super.init()
        _id = ObjectId.generate()
        self.emoji = emoji
        self.name = name
        self.category = category
        self.hex = hex
        self.items = items
        createdAt = .init()
    }

    // MARK: Codable

    enum CodingKeys: CodingKey {
        case _id
        case name
        case category
        case emoji
        case hex
        case items
        case createdAt
    }

    public required init(from decoder: any Decoder) throws {
        super.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decodeIfPresent(CategoryObject.self, forKey: .category)
        emoji = try container.decode(String.self, forKey: .emoji)
        hex = try container.decodeIfPresent(HexObject.self, forKey: .hex)
        items = try container.decode(List<RecordObject>.self, forKey: .items)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self._id, forKey: ._id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.emoji, forKey: .emoji)
        try container.encode(self.hex, forKey: .hex)
        try container.encode(self.items, forKey: .items)
        try container.encode(self.createdAt, forKey: .createdAt)
    }
}

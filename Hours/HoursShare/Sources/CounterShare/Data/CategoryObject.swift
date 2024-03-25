//
//  Task.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/8.
//

import Foundation
import RealmSwift

public class CategoryObject: Object, ObjectKeyIdentifiable, Codable, HexColors {
    @Persisted(primaryKey: true) var _id: ObjectId

    /// 颜色
    @Persisted public var hex: HexObject?
    /// Icon or Emoji 表情
    @Persisted public var icon: String?
    ///  Emoji 表情
    @Persisted public var emoji: String?
    /// 标签名
    @Persisted(indexed: true) public var name: String

    @Persisted public var events: List<EventObject>

    override public init() {
        super.init()
    }

    public init(hex: HexObject?, emoji: String, name: String, events: List<EventObject> = List<EventObject>()) {
        super.init()

        _id = ObjectId.generate()
        self.hex = hex
        self.emoji = emoji
        self.name = name
        self.events = events
    }

    public init(hex: HexObject?, icon: String, name: String, events: List<EventObject> = List<EventObject>()) {
        super.init()

        _id = ObjectId.generate()
        self.hex = hex
        self.icon = icon
        self.name = name
        self.events = events
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case _id
        case hex
        case icon
        case emoji
        case name
        case events
    }

    public required init(from decoder: any Decoder) throws {
        super.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
//        _id = try container.decode(ObjectId.self, forKey: ._id)
        hex = try container.decodeIfPresent(HexObject.self, forKey: .hex)
        icon = try container.decodeIfPresent(String.self, forKey: .icon)
        emoji = try container.decodeIfPresent(String.self, forKey: .emoji)
        name = try container.decode(String.self, forKey: .name)
        events = try container.decode(List<EventObject>.self, forKey: .events)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(_id, forKey: ._id)
        try container.encode(hex, forKey: .hex)
        try container.encode(icon, forKey: .icon)
        try container.encode(emoji, forKey: .emoji)
        try container.encode(name, forKey: .name)
        try container.encode(events, forKey: .events)
    }
}

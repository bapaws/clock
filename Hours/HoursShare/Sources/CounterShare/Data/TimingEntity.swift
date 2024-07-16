//
//  TimingEntity.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/9.
//

import ClockShare
import Foundation
import RealmSwift

/// 当前正在执行中的计时
/// 这里不直接使用 EventEntity，因为可能会超过 LiveActivity 的大小限制
public struct TimingEntity: Identifiable, Codable, HexEntityColors, Hashable {
    public var _id: ObjectId
    /// 名称
    public var name: String

    /// Emoji
    public var emoji: String?
    /// 颜色
    public var hex: HexEntity?

    public var time: Time

    public var id: String { self._id.stringValue }

    public init(event: EventEntity, time: Time = .zero) {
        self._id = event._id
        self.name = event.name
        self.emoji = event.emoji
        self.hex = event.hex

        self.time = time
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case emoji
        case rgb
        case time
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        self._id = try ObjectId(string: id)
        self.name = try container.decode(String.self, forKey: .name)
        self.emoji = try container.decodeIfPresent(String.self, forKey: .emoji)
        if let rgb = try container.decodeIfPresent(Int.self, forKey: .rgb) {
            self.hex = HexEntity(rgb: rgb)
        }
        self.time = try container.decode(Time.self, forKey: .time)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.emoji, forKey: .emoji)
        let rgb = self.hex?.rgb
        try container.encodeIfPresent(rgb, forKey: .rgb)
        try container.encode(self.time, forKey: .time)
    }
}

public extension TimingEntity {
    var date: Date { self.time.date }

    var title: String {
        if let emoji = emoji {
            return emoji + " " + self.name
        }
        return self.name
    }

    static func random() -> TimingEntity {
        TimingEntity(
            event: EventEntity.random(),
            time: .zero
        )
    }
}

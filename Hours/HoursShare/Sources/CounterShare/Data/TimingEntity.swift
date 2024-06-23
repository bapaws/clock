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
public struct TimingEntity: Identifiable, Codable, HexEntityColors {
    public var _id: ObjectId = .generate()
    /// 名称
    public var name: String

    /// Emoji
    public var emoji: String?
    /// 颜色
    public var hex: HexEntity?

    public var time: Time

    public var id: String { _id.stringValue }

    public init(event: EventEntity, time: Time = .zero) {
        self._id = event._id
        self.name = event.name
        self.emoji = event.emoji
        self.hex = event.hex

        self.time = time
    }
}

public extension TimingEntity {
    var date: Date { time.date }

    var title: String {
        if let emoji = emoji {
            return emoji + " " + name
        }
        return name
    }

    static func random() -> TimingEntity {
        TimingEntity(
            event: EventEntity.random(),
            time: .zero
        )
    }
}

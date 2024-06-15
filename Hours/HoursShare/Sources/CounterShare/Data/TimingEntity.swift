//
//  TimingEntity.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/9.
//

import ClockShare
import Foundation

/// 当前正在执行中的计时
public struct TimingEntity: Identifiable, Codable {
    public var event: EventEntity
    public var time: Time

    public var id: String { event.id }

    public init(event: EventEntity, time: Time) {
        self.event = event
        self.time = time
    }
}

public extension TimingEntity {
    var date: Date {
        time.date
    }
}

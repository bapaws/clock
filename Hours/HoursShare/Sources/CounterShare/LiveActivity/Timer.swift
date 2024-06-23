//
//  Timer.swift
//
//
//  Created by 张敏超 on 2024/5/22.
//

import ActivityKit
import ClockShare
import Foundation

public struct TimerContentState: Codable, Hashable {
    public var time: Time

    public init(time: Time) {
        self.time = time
    }
}

@available(iOS 16.1, *)
public struct TimerActivityAttributes: ActivityAttributes {
    public typealias ContentState = TimerContentState

    public let event: TimingEntity

    public static var preview: TimerActivityAttributes {
        TimerActivityAttributes(
            event: TimingEntity(
                event: EventEntity(emoji: "🛌", name: "Sleep", hex: HexEntity(hex: "C9D8CD")),
                time: .zero
            )
        )
    }
}

@available(iOS 16.1, *)
open class TimerActivity {
    public static let shared = TimerActivity()

    public let id = "Timer"

    private var activity: Activity<TimerActivityAttributes>?

    init() {}

    public func start(attributes: TimerActivityAttributes, time: Time) {
        let contentState = TimerActivityAttributes.ContentState(time: time)
        do {
            activity = try Activity.request(attributes: attributes, contentState: contentState, pushType: .token)
        } catch {
            print(error.localizedDescription)
        }
    }

    public func update(time: Time) {
        let contentState = TimerActivityAttributes.ContentState(time: time)
        Task {
            await self.activity?.update(using: contentState)
        }
    }

    public func stop() {
        Task {
            await self.activity?.end(using: nil, dismissalPolicy: .immediate)
            self.activity = nil
        }
    }
}

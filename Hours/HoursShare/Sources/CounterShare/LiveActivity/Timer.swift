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

    public let event: EventObject

    public static var preview: TimerActivityAttributes {
        TimerActivityAttributes(
            event: EventObject(emoji: "🛌", name: R.string.localizable.sleep(), hex: HexObject(hex: "C9D8CD"), isSystem: true)
        )
    }
}

@available(iOS 16.1, *)
open class TimerActivity {
    public static let shared = TimerActivity()

    public let id = "Timer"

    private var activity: Activity<TimerActivityAttributes>?

    public init() {}

    public func start(attributes: TimerActivityAttributes, time: Time) {
        Task {
            let contentState = TimerActivityAttributes.ContentState(time: time)
            do {
                activity = try Activity.request(attributes: attributes, contentState: contentState, pushType: .token)
            } catch {
                print(error.localizedDescription)
            }
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

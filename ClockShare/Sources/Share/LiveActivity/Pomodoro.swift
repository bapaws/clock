//
//  File.swift
//
//
//  Created by 张敏超 on 2024/1/10.
//

import ActivityKit
import Foundation

// public struct PomodoroAttributes: ActivityAttributes {
//    public struct ContentState: Codable, Hashable {
//        public var time: Time
//
//        public init(time: Time) {
//            self.time = time
//        }
//    }
//
//    public var minutes: Int = 25
//    public var state: PomodoroState
//
//    public private(set) var colorType: ColorType
//    public private(set) var colors: Colors
//    public private(set) var appIcon: AppIconType
//
//    public init(
//        minutes: Int,
//        state: PomodoroState,
//        colorType: ColorType? = nil,
//        colors: Colors? = nil,
//        appIcon: AppIconType? = nil
//    ) {
//        self.minutes = minutes
//        self.state = state
//
//        self.colorType = colorType ?? UIManager.shared.colorType
//        self.colors = colors ?? UIManager.shared.colors
//        self.appIcon = appIcon ?? UIManager.shared.appIcon
//    }
// }

public struct PomodoroContentState: Codable, Hashable {
    public var time: Time

    public init(time: Time) {
        self.time = time
    }

    public var startAt: Date {
        time.date
    }

    public var endAt: Date {
        time.date.addingTimeInterval(TimeInterval(time.milliseconds) / 1000)
    }

    public var range: ClosedRange<Date> {
        startAt ... endAt
    }
}

@available(iOS 16.1, *)
public protocol PomodoroActivityAttributes: ActivityAttributes {
    associatedtype C: ThemeColors

    var seconds: Int { set get }
    var state: PomodoroState { set get }

    var colorType: ColorType { get }
    var colors: C { get }
    var appIcon: AppIconType { get }

    init(
        seconds: Int,
        state: PomodoroState,
        colorType: ColorType?,
        colors: C?,
        appIcon: AppIconType?
    )
}

@available(iOS 16.1, *)
open class PomodoroActivity<Attributes: PomodoroActivityAttributes> where Attributes.ContentState == PomodoroContentState {
    public let pomodoroID = "Pomodoro"

    private var activity: Activity<Attributes>?

    public init() {}

    public func start(attributes: Attributes, time: Time) {
        Task {
            let contentState = Attributes.ContentState(time: time)
            do {
                activity = try Activity.request(attributes: attributes, contentState: contentState, pushType: .token)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    public func update(time: Time) {
        let contentState = Attributes.ContentState(time: time)
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

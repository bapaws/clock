//
//  PomodoroManager.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/21.
//

import ClockShare
import Foundation

public struct PomodoroAttributes: ClockShare.PomodoroActivityAttributes {
    public typealias ContentState = ClockShare.PomodoroContentState

    public var minutes: Int = 25
    public var state: PomodoroState

    public private(set) var colorType: ColorType
    public private(set) var colors: Colors
    public private(set) var appIcon: AppIconType

    public init(
        minutes: Int,
        state: PomodoroState,
        colorType: ColorType? = nil,
        colors: Colors? = nil,
        appIcon: AppIconType? = nil
    ) {
        self.minutes = minutes
        self.state = state

        self.colorType = colorType ?? UIManager.shared.colorType
        self.colors = colors ?? UIManager.shared.colors
        self.appIcon = appIcon ?? UIManager.shared.appIcon
    }
}

@available(iOS 16.1, *)
public class PomodoroActivity: ClockShare.PomodoroActivity<PomodoroAttributes> {
    public static let shared = PomodoroActivity()

    override init() { super.init() }
}

public class PomodoroManager: ClockShare.PomodoroBaseManager {
    public static let shared = PomodoroManager()

    private override init() {
        super.init()
    }

    override public func didSetState() {
        super.didSetState()

        if #available(iOS 16.1, *) {
            if state == .none || state == .focusCompleted {
                PomodoroActivity.shared.stop()
            } else {
                var minutes = focusMinutes
                switch state {
                case .focusCompleted, .shortBreak:
                    minutes = shortBreakMinutes
                case .longBreak:
                    minutes = longBreakMinutes
                default:
                    minutes = focusMinutes
                }

                let attributes = PomodoroAttributes(minutes: minutes, state: state)
                PomodoroActivity.shared.start(attributes: attributes, time: time)
            }
        }
    }

    override public func activityUpdate(time: Time) {
        if #available(iOS 16.1, *) {
            PomodoroActivity.shared.update(time: time)
        }
    }
}

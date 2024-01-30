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

    public var seconds: Int = 25
    public var state: PomodoroState

    public private(set) var colorType: ColorType
    public private(set) var colors: Colors
    public private(set) var appIcon: AppIconType

    public init(
        seconds: Int,
        state: PomodoroState,
        colorType: ColorType? = nil,
        colors: Colors? = nil,
        appIcon: AppIconType? = nil
    ) {
        self.seconds = seconds
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

    override private init() {
        super.init()
    }

    override public func didSetState() {
        super.didSetState()

        if #available(iOS 16.1, *) {
            if state == .none || state == .focusCompleted {
                PomodoroActivity.shared.stop()
            } else {
                var seconds = focusMinutes * 60
#if DEBUG
                switch state {
                case .focusCompleted, .shortBreak:
                    seconds = 5 * 60
                case .longBreak:
                    seconds = 6
                default:
                    seconds = 60 + 9
                }
#else
                switch state {
                case .focusCompleted, .shortBreak:
                    seconds = shortBreakMinutes * 60
                case .longBreak:
                    seconds = longBreakMinutes * 60
                default:
                    seconds = focusMinutes * 60
                }
#endif

                let attributes = PomodoroAttributes(seconds: seconds, state: state)
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

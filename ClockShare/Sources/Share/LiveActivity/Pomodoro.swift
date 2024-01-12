//
//  File.swift
//
//
//  Created by 张敏超 on 2024/1/10.
//

import ActivityKit
import Foundation

public struct PomodoroAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var time: Time

        public init(time: Time) {
            self.time = time
        }
    }

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
public class PomodoroActivity {
    // 使用单例，避免版本判断的问题
    public static let shared = PomodoroActivity()

    public static let pomodoroID = "Pomodoro"

    private var activity: Activity<PomodoroAttributes>?

    public func start(attributes: PomodoroAttributes, time: Time) {
        Task {
            let contentState = PomodoroAttributes.ContentState(time: time)
            do {
                activity = try Activity.request(attributes: attributes, contentState: contentState, pushType: .token)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    public func update(time: Time) {
        let contentState = PomodoroAttributes.ContentState(time: time)
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

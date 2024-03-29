//
//  StopLiveActivityIntent.swift
//  DeskClockWidgetExtension
//
//  Created by 张敏超 on 2024/1/11.
//

import ActivityKit
import AppIntents
import ClockShare
import DeskClockShare
import WidgetKit

@available(iOS 16.1, *)
struct StopLiveActivityIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "AppName"
    static var description = IntentDescription("Slogan")

    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            PomodoroManager.shared.stop()
        }
        return .result()
    }
}

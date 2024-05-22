//
//  StopTimerLiveActivityIntent.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/5/22.
//

import AppIntents
import ClockShare
import Foundation

@available(iOS 16.1, *)
struct StopTimerLiveActivityIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "AppName"
    static var description = IntentDescription("Slogan")

    static var openAppWhenRun: Bool { true }

    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            TimerManager.shared.stop()
        }
        return .result()
    }
}

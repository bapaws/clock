//
//  QuickStopTimerAppIntent.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/6.
//

import AppIntents
import ClockShare
import Foundation
import HoursShare

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct QuickStopTimerAppIntent: AppIntent {
    static var title: LocalizedStringResource = "QuickTiming"
    static var description = IntentDescription("Quick Timing")

    init() {}

    func perform() async throws -> some IntentResult {
        guard let entity = Storage.default.currentTimingEntity else { return .result() }

        let time = entity.time
        let milliseconds = min(time.milliseconds, Int(AppManager.shared.maximumRecordedTime * 1000))
        let newRecord = RecordEntity(creationMode: .timer, startAt: time.initialDate, milliseconds: milliseconds, endAt: time.date)
        try await AppRealm.shared.writeRecord(newRecord, addTo: entity.event)

        NotificationCenter.default.post(name: TimerManager.shared.timerStop, object: nil)

        TimerManager.shared.stop()

        return .result()
    }
}

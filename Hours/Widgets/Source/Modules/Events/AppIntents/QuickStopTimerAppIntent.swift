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
        guard let entity = Storage.default.currentTimingEntity, let event = await AppRealm.shared.getEvent(by: entity.id) else {
            return .result()
        }

        var time = entity.time
        // 这里先调用 ++，相当于计时
        time++
        let milliseconds = min(time.milliseconds, Int(AppManager.shared.maximumRecordedTime * 1000))
        var newRecord = RecordEntity(creationMode: .timer, startAt: time.initialDate, milliseconds: milliseconds, endAt: time.date)
        newRecord.calendarEventIdentifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
        await AppRealm.shared.writeRecord(newRecord, addTo: event)

        NotificationCenter.default.post(name: TimerManager.shared.timerStop, object: nil)

        TimerManager.shared.stop()

        return .result()
    }
}

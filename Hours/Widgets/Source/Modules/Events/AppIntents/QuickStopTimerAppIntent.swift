//
//  QuickStopTimerAppIntent.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/6.
//

import AppIntents
import ClockShare
import Dependencies
import Foundation
import HoursShare

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct QuickStopTimerAppIntent: AppIntent, LiveActivityIntent {
    static var title: LocalizedStringResource = "QuickTiming"
    static var description = IntentDescription("Quick Timing")

    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    static var isDiscoverable: Bool { return false }

    var app: AppManager { AppManager.shared }

    @Parameter(title: "EventID")
    var eventID: String

    init() {}

    init(eventID: String) {
        self.eventID = eventID
    }

    func perform() async throws -> some IntentResult {
        guard let entity = TimerManager.shared.timingEntities.first(where: { $0.id == eventID }) else {
            return .result()
        }

        Task {
            var time = entity.time
            // 这里先调用 ++，相当于计时
            time++

            guard let event = await AppRealm.shared.getEvent(by: eventID) else {
                return
            }

            let milliseconds = app.limitMaximumDuration ? min(time.milliseconds, Int(app.maximumRecordedTime * 1000)) : time.milliseconds
            var newRecord = RecordEntity(creationMode: .timer, startAt: time.initialDate, milliseconds: milliseconds, endAt: time.date)
            newRecord.calendarEventIdentifier = await AppManager.shared.syncToCalendar(for: event, record: newRecord)
            await AppRealm.shared.writeRecord(newRecord, addTo: event)
        }

        NotificationCenter.default.post(name: TimerManager.shared.timerStop, object: nil)
        TimerManager.shared.stop(of: entity, reloadTimelines: false)

        return .result()
    }
}

//
//  QuickStartTimerAppIntent.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/6.
//

import AppIntents
import ClockShare
import Foundation
import HoursShare

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct QuickStartTimerAppIntent: AppIntent {
    static var title: LocalizedStringResource = "QuickTiming"
    static var description = IntentDescription("Quick Timing")

    @Parameter(title: "EventID")
    var eventID: String

    init() {}

    init(eventID: String) {
        self.eventID = eventID
    }

    func perform() async throws -> some IntentResult {
        guard let eventEntity = await AppRealm.shared.getEvent(by: eventID) else { return .result() }
        let entity = TimingEntity(event: eventEntity, time: .zero)
        Storage.default.currentTimingEntity = entity

        NotificationCenter.default.post(name: TimerManager.shared.timerStart, object: nil)

        TimerManager.shared.start(of: entity)
        return .result()
    }
}

@available(iOSApplicationExtension, unavailable)
extension QuickStartTimerAppIntent: ForegroundContinuableIntent {}

//
//  StopTimerLiveActivityIntent.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/5/22.
//

import AppIntents
import ClockShare
import Foundation
import HoursShare
import RealmSwift

@available(iOS 17.0, *)
struct StopTimerLiveActivityIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "AppName"
    static var description = IntentDescription("Slogan")

    static var openAppWhenRun: Bool { false }

    func perform() async throws -> some IntentResult {
        guard let entity = Storage.default.currentTimingEntity, let event = await AppRealm.shared.getEvent(by: entity.id) else {
            return .result()
        }

        var time = entity.time
        // 这里先调用 ++，相当于计时
        time++

        let milliseconds = min(time.milliseconds, Int(AppManager.shared.maximumRecordedTime * 1000))
        let newRecord = RecordEntity(creationMode: .timer, startAt: time.initialDate, milliseconds: milliseconds, endAt: time.date)
        await AppRealm.shared.writeRecord(newRecord, addTo: event)

        NotificationCenter.default.post(name: TimerManager.shared.timerStop, object: nil)

        TimerManager.shared.stop()

        return .result()
    }
}

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
        DispatchQueue.main.async {
            guard let id = Storage.default.currentTimerEventID, let primaryKey = try? ObjectId(string: id) else { return }
            guard var time = Storage.default.currentTimerTime else { return }

            let realm = DBManager.default.realm
            guard let event = realm.object(ofType: EventObject.self, forPrimaryKey: primaryKey) else { return }

            time++

            realm.writeAsync {
                let milliseconds = min(time.milliseconds, Int(AppManager.shared.maximumRecordedTime * 1000))
                let newRecord = RecordObject(creationMode: .timer, startAt: time.initialDate, milliseconds: milliseconds, endAt: time.date)
                // 同步到日历应用
                let eventIdendtifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
                newRecord.calendarEventIdentifier = eventIdendtifier
                realm.add(newRecord)

                event.items.append(newRecord)
            }

            NotificationCenter.default.post(name: TimerManager.shared.timerStop, object: nil)

            TimerManager.shared.stop()
        }
        return .result()
    }
}

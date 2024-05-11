//
//  NewRecordAppIntent.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/9.
//

import AppIntents
import Foundation
import HoursShare
import RealmSwift

struct NewRecordAppIntent: AppIntent {
    static var title: LocalizedStringResource = "NewRecord"

    @Parameter(title: "Event", optionsProvider: EventProvider())
    var eventID: String

    @Parameter(title: "StartTime")
    var startAt: Date
    @Parameter(title: "EndTime")
    var endAt: Date

    @MainActor func perform() async throws -> some IntentResult {
        let event = DBManager.default.events.first { $0._id.stringValue == eventID }
        guard let event = event?.thaw(), let realm = event.realm else {
            return .result(value: "")
        }

        realm.writeAsync {
            let newRecord = RecordObject(creationMode: .shortcut, startAt: startAt, endAt: endAt)
            let identifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
            newRecord.calendarEventIdentifier = identifier
            realm.add(newRecord)

            event.items.append(newRecord)
        }

        return .result(value: "")
    }
}

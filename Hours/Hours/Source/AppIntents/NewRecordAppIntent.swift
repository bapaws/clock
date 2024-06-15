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
        guard let event = await AppRealm.shared.getEvent(by: eventID) else { return .result() }

        var newRecord = RecordEntity(creationMode: .shortcut, startAt: startAt, endAt: endAt)
        let identifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
        newRecord.calendarEventIdentifier = identifier
        await AppRealm.shared.writeRecord(newRecord, addTo: event)

        return .result()
    }
}

//
//  AppDidCloseAppIntent.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/9.
//

import AppIntents
import Foundation
import HoursShare
import RealmSwift

struct AppDidCloseAppIntent: AppIntent {
    static var title: LocalizedStringResource = "AppDidClose"

    static var description: IntentDescription? = "Dese"

    @Parameter(title: "Event", optionsProvider: EventProvider())
    var eventID: String

    static var parameterSummary: some ParameterSummary {
        Summary("App is closed. Create a record for \(\.$eventID)")
    }

    @MainActor func perform() async throws -> some IntentResult {
        guard let startAt = UserDefaults.standard.value(forKey: "AppDidOpen") as? Date else {
            return .result()
        }
        let endAt = Date()

        defer { UserDefaults.standard.removeObject(forKey: "AppDidOpen") }

        debugPrint(eventID)
        guard let event = await AppRealm.shared.getEvent(by: eventID) else { return .result() }

        // 当设置自动合并是，执行合并记录的逻辑
        if AppManager.shared.isAutoMergeAdjacentRecords {
            let minEndAt = startAt.addingTimeInterval(-AppManager.shared.autoMergeAdjacentRecordsInterval)
            if var record = await AppRealm.shared.getRecord(of: event, minEndAt: minEndAt) {
                record.endAt = endAt
                // 先完成更新，后同步日历
                let identifier = AppManager.shared.syncToCalendar(for: event, record: record)
                record.calendarEventIdentifier = identifier

                await AppRealm.shared.updateRecord(record)

                return .result()
            }
        }

        // 小于最低记录时长时，不记录
        if endAt.timeIntervalSince1970 - startAt.timeIntervalSince1970 < AppManager.shared.minimumRecordedScreenTime {
            return .result()
        }

        var newRecord = RecordEntity(creationMode: .shortcut, startAt: startAt, endAt: endAt)
        let identifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
        newRecord.calendarEventIdentifier = identifier
        await AppRealm.shared.writeRecord(newRecord, addTo: event)

        return .result()
    }
}

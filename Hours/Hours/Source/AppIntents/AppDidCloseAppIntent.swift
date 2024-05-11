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

    func perform() async throws -> some IntentResult {
        guard let startAt = UserDefaults.standard.value(forKey: "AppDidOpen") as? Date else { return .result(value: "") }
        let endAt = Date()

        print(eventID)
        let event = DBManager.default.events.first { $0._id.stringValue == eventID }

        guard let event = event?.thaw(), let realm = event.realm else {
            return .result(value: "")
        }

        // 当设置自动合并是，执行合并记录的逻辑
        if AppManager.shared.isAutoMergeAdjacentRecords {
            let minEndAt = startAt.addingTimeInterval(-AppManager.shared.autoMergeAdjacentRecordsInterval)
            if let record = realm.objects(RecordObject.self)
                .where({ $0.event == event && $0.endAt > minEndAt })
                .first {
                record.realm?.writeAsync {
                    record.endAt = endAt
                }
                return .result(value: "")
            }
        }

        realm.writeAsync {
            let newRecord = RecordObject(creationMode: .enter, startAt: startAt, endAt: endAt)
            let identifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
            newRecord.calendarEventIdentifier = identifier
            realm.add(newRecord)

            event.items.append(newRecord)
        }

        return .result(value: "")
    }
}

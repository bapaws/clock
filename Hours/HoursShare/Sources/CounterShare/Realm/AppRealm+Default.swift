//
//  File.swift
//
//
//  Created by 张敏超 on 2024/8/6.
//

import Foundation
import RealmSwift
import SwiftDate

public extension AppRealm {
    static let healthCategoryID = "66caf6927d73061e0ec14d3f"
    static let sleepEventID = "66caf6927d73061e0ec14d40"

    func importDefaults(categories: [CategoryEntity]) async {
        let realm = await realm
        for category in categories {
            if let object = realm.objects(CategoryObject.self).where({ $0.name == category.name && $0.emoji == category.emoji }).first {
                for event in category.events {
                    try? await realm.asyncWrite {
                        object.deletedAt = nil
                    }
                    await AppRealm.shared.writeEvent(event, addTo: object)
                }
            } else {
                try? await realm.asyncWrite {
                    realm.add(category.toObject())
                }
            }
        }
    }

    func generateRandomRecords() async {
#if DEBUG
        do {
            let realm = await realm
//            let records = realm.objects(RecordObject.self)
//            try await realm.asyncWrite {
//                for record in records {
//                    record.deletedAt = .now
//                }
//            }

            let events = realm.objects(EventObject.self).where { $0.deletedAt == nil && $0.archivedAt == nil }
            if events.isEmpty { return }

            var startAt = realm.objects(RecordObject.self)
                .where { $0.deletedAt == nil }
                .sorted(by: \.endAt).last?.endAt ??
                Date(year: 2024, month: 4, day: 7, hour: 8, minute: 0)
            try await realm.asyncWrite {
                let now = Date.now
                while startAt < now {
                    let milliseconds = Int.random(in: 60000...7200000)

                    if Int.random(in: 0...4) == 0 {
                        let mode = RecordCreationMode(rawValue: Int.random(in: 0...2))!
                        let record = RecordObject(creationMode: mode, startAt: startAt, milliseconds: milliseconds)
                        realm.add(record)

                        let index = Int.random(in: 0 ..< events.count)
                        events[index].items.append(record)
                    }

                    startAt = startAt.addingTimeInterval(TimeInterval(milliseconds) / 1000)
                }
            }
        } catch {
            debugPrint(error)
        }

#endif
    }
}

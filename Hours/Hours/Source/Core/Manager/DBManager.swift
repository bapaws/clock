//
//  DBManager.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/6.
//

import Foundation
import HoursShare
import RealmSwift
import SwiftUI
import UIKit

public extension DBManager {
    func setup() {
        #if DEBUG
            try? realm.write {
                realm.deleteAll()
            }
        #endif

        if schemaVersion == 0 {
            guard self.categorys.isEmpty, self.hexs.isEmpty else { return }

            try? realm.write {
                let lifeEvents = RealmSwift.List<EventObject>()
                lifeEvents.append(EventObject(emoji: "🪥", name: R.string.localizable.personalGrooming(), hex: HexObject(hex: "#E4CECE")))
                lifeEvents.append(EventObject(emoji: "✈️", name: R.string.localizable.travel(), hex: HexObject(hex: "#BCCBB0")))
                lifeEvents.append(EventObject(emoji: "🛒", name: R.string.localizable.shopping(), hex: HexObject(hex: "#D9D19B")))
                let life = CategoryObject(hex: HexObject(hex: "#E3BEF2"), emoji: "🛀", name: R.string.localizable.life(), events: lifeEvents)
                self.realm.add(life)

                let workEvents = RealmSwift.List<EventObject>()
                workEvents.append(EventObject(emoji: "💼", name: R.string.localizable.work(), hex: HexObject(hex: "#99A4BC")))
                workEvents.append(EventObject(emoji: "👩‍💻", name: R.string.localizable.coding(), hex: HexObject(hex: "#9C9E89")))
                let work = CategoryObject(hex: HexObject(hex: "#DBEAB3"), emoji: "🧑🏻‍💻", name: R.string.localizable.work(), events: workEvents)
                self.realm.add(work)

                let studyEvents = RealmSwift.List<EventObject>()
                studyEvents.append(EventObject(emoji: "📚", name: R.string.localizable.reading(), hex: HexObject(hex: "#C80926")))
                studyEvents.append(EventObject(emoji: "🗣️", name: R.string.localizable.english(), hex: HexObject(hex: "0A1053")))
                studyEvents.append(EventObject(emoji: "📐", name: R.string.localizable.math(), hex: HexObject(hex: "595E66")))
                studyEvents.append(EventObject(emoji: "✍️", name: R.string.localizable.exam(), hex: HexObject(hex: "806247")))
                let study = CategoryObject(hex: HexObject(hex: "#FDDFDF"), emoji: "📖", name: R.string.localizable.study(), events: studyEvents)
                self.realm.add(study)

                let sportsEvents = RealmSwift.List<EventObject>()
                sportsEvents.append(EventObject(emoji: "🏃‍♂️", name: R.string.localizable.running(), hex: HexObject(hex: "A79A7B")))
                sportsEvents.append(EventObject(emoji: "🏊‍♂️", name: R.string.localizable.swimming(), hex: HexObject(hex: "B1886A")))
                let sports = CategoryObject(hex: HexObject(hex: "#EDDD9E"), emoji: "🏃", name: R.string.localizable.sports(), events: sportsEvents)
                self.realm.add(sports)

                let entertainmentEvents = RealmSwift.List<EventObject>()
                entertainmentEvents.append(EventObject(emoji: "🎵", name: R.string.localizable.music(), hex: HexObject(hex: "C1C19C")))
                entertainmentEvents.append(EventObject(emoji: "📺", name: R.string.localizable.video(), hex: HexObject(hex: "1E3124")))
                entertainmentEvents.append(EventObject(emoji: "🎮", name: R.string.localizable.game(), hex: HexObject(hex: "FFFAE8")))
                let entertainment = CategoryObject(hex: HexObject(hex: "#78C2C4"), emoji: "🎮", name: R.string.localizable.entertainment(), events: entertainmentEvents)
                self.realm.add(entertainment)

                let breakEvents = RealmSwift.List<EventObject>()
                breakEvents.append(EventObject(emoji: "😴", name: R.string.localizable.middayNap(), hex: HexObject(hex: "E88B00")))
                breakEvents.append(EventObject(emoji: "🍰", name: R.string.localizable.afternoonTea(), hex: HexObject(hex: "FF441A")))
                breakEvents.append(EventObject(emoji: "🛌", name: R.string.localizable.sleep(), hex: HexObject(hex: "C9D8CD"), isSystem: true))
                let `break` = CategoryObject(hex: HexObject(hex: "#CAC3D4"), emoji: "🛋", name: R.string.localizable.break(), events: breakEvents)
                self.realm.add(`break`)

                let houseworkEvents = RealmSwift.List<EventObject>()
                houseworkEvents.append(EventObject(emoji: "🧹", name: R.string.localizable.cleaning(), hex: HexObject(hex: "405742")))
                houseworkEvents.append(EventObject(emoji: "🍳", name: R.string.localizable.cooking(), hex: HexObject(hex: "3F4470")))
                let housework = CategoryObject(hex: HexObject(hex: "#E38C7A"), emoji: "🧹", name: R.string.localizable.housework(), events: houseworkEvents)
                self.realm.add(housework)
            }

            if let jsonData = nipponColors.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let colors = try decoder.decode([OneColor].self, from: jsonData)
                    let hexs = colors.map { HexObject(hex: $0.hex) }
                    try realm.write {
                        self.realm.add(hexs)
                    }
                } catch {
                    print("\(error)")
                }
            }

            self.hexs = realm.objects(HexObject.self)
            self.categorys = realm.objects(CategoryObject.self)
        }

        #if DEBUG
            let events = realm.objects(EventObject.self)
            try? realm.write {
                let now = Date.now
                var startAt = AppManager.shared.initialDate
                while startAt < now {
                    let milliseconds = Int.random(in: 60000...7200000)
                    let mode = RecordCreationMode(rawValue: Int.random(in: 0...2))!
                    let record = RecordObject(creationMode: mode, startAt: startAt, milliseconds: milliseconds)
                    realm.add(record)

                    let index = Int.random(in: 0 ..< events.count)
                    events[index].items.append(record)

                    startAt = startAt.addingTimeInterval(TimeInterval(milliseconds) / 1000)
                }
            }
        #endif
    }
}

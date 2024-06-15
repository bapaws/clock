//
//  CategoryEntity.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/5.
//

import Foundation
import RealmSwift

public extension CategoryObject {
    static var defaults: RealmSwift.List<CategoryObject> {
        let categries = RealmSwift.List<CategoryObject>()

        let lifeEvents = RealmSwift.List<EventObject>()
        lifeEvents.append(EventObject(emoji: "🪥", name: R.string.localizable.personalGrooming(), hex: HexObject(hex: "#E4CECE")))
        lifeEvents.append(EventObject(emoji: "✈️", name: R.string.localizable.travel(), hex: HexObject(hex: "#BCCBB0")))
        lifeEvents.append(EventObject(emoji: "🛒", name: R.string.localizable.shopping(), hex: HexObject(hex: "#D9D19B")))
        let life = CategoryObject(hex: HexObject(hex: "#E3BEF2"), emoji: "🏠", name: R.string.localizable.life(), events: lifeEvents)
        categries.append(life)

        let workEvents = RealmSwift.List<EventObject>()
        workEvents.append(EventObject(emoji: "💼", name: R.string.localizable.work(), hex: HexObject(hex: "#99A4BC")))
        workEvents.append(EventObject(emoji: "👩‍💻", name: R.string.localizable.coding(), hex: HexObject(hex: "#9C9E89")))
        let work = CategoryObject(hex: HexObject(hex: "#DBEAB3"), emoji: "🧑🏻‍💻", name: R.string.localizable.work(), events: workEvents)
        categries.append(work)

        let studyEvents = RealmSwift.List<EventObject>()
        studyEvents.append(EventObject(emoji: "📚", name: R.string.localizable.reading(), hex: HexObject(hex: "#C80926")))
        studyEvents.append(EventObject(emoji: "🗣️", name: R.string.localizable.english(), hex: HexObject(hex: "0A1053")))
        studyEvents.append(EventObject(emoji: "📐", name: R.string.localizable.math(), hex: HexObject(hex: "595E66")))
        studyEvents.append(EventObject(emoji: "✍️", name: R.string.localizable.exam(), hex: HexObject(hex: "806247")))
        let study = CategoryObject(hex: HexObject(hex: "#FDDFDF"), emoji: "📖", name: R.string.localizable.study(), events: studyEvents)
        categries.append(study)

        let sportsEvents = RealmSwift.List<EventObject>()
        sportsEvents.append(EventObject(emoji: "🏃‍♂️", name: R.string.localizable.running(), hex: HexObject(hex: "A79A7B")))
        sportsEvents.append(EventObject(emoji: "🏊‍♂️", name: R.string.localizable.swimming(), hex: HexObject(hex: "B1886A")))
        let sports = CategoryObject(hex: HexObject(hex: "#EDDD9E"), emoji: "🏃", name: R.string.localizable.sports(), events: sportsEvents)
        categries.append(sports)

        let entertainmentEvents = RealmSwift.List<EventObject>()
        entertainmentEvents.append(EventObject(emoji: "🎵", name: R.string.localizable.music(), hex: HexObject(hex: "C1C19C")))
        entertainmentEvents.append(EventObject(emoji: "📺", name: R.string.localizable.video(), hex: HexObject(hex: "1E3124")))
        entertainmentEvents.append(EventObject(emoji: "🎮", name: R.string.localizable.game(), hex: HexObject(hex: "FFFAE8")))
        let entertainment = CategoryObject(hex: HexObject(hex: "#78C2C4"), emoji: "🎮", name: R.string.localizable.entertainment(), events: entertainmentEvents)
        categries.append(entertainment)

        let houseworkEvents = RealmSwift.List<EventObject>()
        houseworkEvents.append(EventObject(emoji: "🧹", name: R.string.localizable.cleaning(), hex: HexObject(hex: "405742")))
        houseworkEvents.append(EventObject(emoji: "🍳", name: R.string.localizable.cooking(), hex: HexObject(hex: "3F4470")))
        let housework = CategoryObject(hex: HexObject(hex: "#20ABEE"), emoji: "🧹", name: R.string.localizable.housework(), events: houseworkEvents)
        categries.append(housework)

        let healthEvents = RealmSwift.List<EventObject>()
        healthEvents.append(EventObject(emoji: "🛌", name: R.string.localizable.sleep(), hex: HexObject(hex: "C9D8CD"), isSystem: true))
        let health = CategoryObject(hex: HexObject(hex: "#FF4033"), emoji: "❤️", name: R.string.localizable.health())
        categries.append(health)

        return categries
    }
}

public extension CategoryEntity {
    static var defaults: [CategoryEntity] {
        var entities = [CategoryEntity]()

        var lifeEvents = [EventEntity]()
        lifeEvents.append(EventEntity(emoji: "🪥", name: R.string.localizable.personalGrooming(), hex: HexEntity(hex: "#E4CECE")))
        lifeEvents.append(EventEntity(emoji: "✈️", name: R.string.localizable.travel(), hex: HexEntity(hex: "#BCCBB0")))
        lifeEvents.append(EventEntity(emoji: "🛒", name: R.string.localizable.shopping(), hex: HexEntity(hex: "#D9D19B")))
        let life = CategoryEntity(hex: HexEntity(hex: "#E3BEF2"), emoji: "🏠", name: R.string.localizable.life(), events: lifeEvents)
        entities.append(life)

        var workEvents = [EventEntity]()
        workEvents.append(EventEntity(emoji: "💼", name: R.string.localizable.work(), hex: HexEntity(hex: "#99A4BC")))
        workEvents.append(EventEntity(emoji: "👩‍💻", name: R.string.localizable.coding(), hex: HexEntity(hex: "#9C9E89")))
        let work = CategoryEntity(hex: HexEntity(hex: "#DBEAB3"), emoji: "🧑🏻‍💻", name: R.string.localizable.work(), events: workEvents)
        entities.append(work)

        var studyEvents = [EventEntity]()
        studyEvents.append(EventEntity(emoji: "📚", name: R.string.localizable.reading(), hex: HexEntity(hex: "#C80926")))
        studyEvents.append(EventEntity(emoji: "🗣️", name: R.string.localizable.english(), hex: HexEntity(hex: "0A1053")))
        studyEvents.append(EventEntity(emoji: "📐", name: R.string.localizable.math(), hex: HexEntity(hex: "595E66")))
        studyEvents.append(EventEntity(emoji: "✍️", name: R.string.localizable.exam(), hex: HexEntity(hex: "806247")))
        let study = CategoryEntity(hex: HexEntity(hex: "#FDDFDF"), emoji: "📖", name: R.string.localizable.study(), events: studyEvents)
        entities.append(study)

        var sportsEvents = [EventEntity]()
        sportsEvents.append(EventEntity(emoji: "🏃‍♂️", name: R.string.localizable.running(), hex: HexEntity(hex: "A79A7B")))
        sportsEvents.append(EventEntity(emoji: "🏊‍♂️", name: R.string.localizable.swimming(), hex: HexEntity(hex: "B1886A")))
        let sports = CategoryEntity(hex: HexEntity(hex: "#EDDD9E"), emoji: "🏃", name: R.string.localizable.sports(), events: sportsEvents)
        entities.append(sports)

        var entertainmentEvents = [EventEntity]()
        entertainmentEvents.append(EventEntity(emoji: "🎵", name: R.string.localizable.music(), hex: HexEntity(hex: "C1C19C")))
        entertainmentEvents.append(EventEntity(emoji: "📺", name: R.string.localizable.video(), hex: HexEntity(hex: "1E3124")))
        entertainmentEvents.append(EventEntity(emoji: "🎮", name: R.string.localizable.game(), hex: HexEntity(hex: "FFFAE8")))
        let entertainment = CategoryEntity(hex: HexEntity(hex: "#78C2C4"), emoji: "🎮", name: R.string.localizable.entertainment(), events: entertainmentEvents)
        entities.append(entertainment)

        var houseworkEvents = [EventEntity]()
        houseworkEvents.append(EventEntity(emoji: "🧹", name: R.string.localizable.cleaning(), hex: HexEntity(hex: "405742")))
        houseworkEvents.append(EventEntity(emoji: "🍳", name: R.string.localizable.cooking(), hex: HexEntity(hex: "3F4470")))
        let housework = CategoryEntity(hex: HexEntity(hex: "#20ABEE"), emoji: "🧹", name: R.string.localizable.housework(), events: houseworkEvents)
        entities.append(housework)

        var healthEvents = [EventEntity]()
        healthEvents.append(EventEntity(emoji: "🛌", name: R.string.localizable.sleep(), hex: HexEntity(hex: "C9D8CD"), isSystem: true))
        let health = CategoryEntity(hex: HexEntity(hex: "#FF4033"), emoji: "❤️", name: R.string.localizable.health())
        entities.append(health)

        return entities
    }
}

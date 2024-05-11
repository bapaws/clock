//
//  EventAppEntity.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/9.
//

import AppIntents
import Foundation
import HoursShare

struct EventAppEntity: AppEntity {
    // Entity ID
    let id: String
    let title: String?

    // 如何显示Entity
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "CalendarAppEntity"
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(title: LocalizedStringResource(stringLiteral: title ?? "app_name"))
    }

    static var defaultQuery = EventEntityQuery()
}

struct EventEntityQuery: EntityQuery {
    var category: CategoryAppEntity?

    @MainActor func entities(for identifiers: [EventAppEntity.ID]) async throws -> [EventAppEntity] {
        DBManager.default.categorys
            .filter { identifiers.contains($0._id.stringValue) }
            .map { EventAppEntity(id: $0._id.stringValue, title: $0.title) }
    }

    @MainActor func suggestedEntities() async throws -> [EventAppEntity] {
        DBManager.default.categorys
            .map { EventAppEntity(id: $0._id.stringValue, title: $0.title) }
    }
}

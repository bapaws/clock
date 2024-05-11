//
//  CategoryAppEntity.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/9.
//

import AppIntents
import Foundation
import HoursShare

struct CategoryAppEntity: AppEntity {
    // Entity ID
    let id: String
    let title: String?

    // 如何显示Entity
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "CalendarAppEntity"
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(title: LocalizedStringResource(stringLiteral: title ?? "app_name"))
    }

    static var defaultQuery = CategoryEntityQuery()
}

struct CategoryEntityQuery: EntityQuery {
    @MainActor func entities(for identifiers: [CategoryAppEntity.ID]) async throws -> [CategoryAppEntity] {
        DBManager.default.categorys
            .filter { identifiers.contains($0._id.stringValue) }
            .map { CategoryAppEntity(id: $0._id.stringValue, title: $0.title) }
    }

    @MainActor func suggestedEntities() async throws -> [CategoryAppEntity] {
        DBManager.default.categorys
            .map { CategoryAppEntity(id: $0._id.stringValue, title: $0.title) }
    }
}

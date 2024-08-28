//
//  QuickSelectCategoryConfigurationIntent.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/28.
//

import AppIntents
import Foundation
import HoursShare
import RealmSwift

struct QuickCategoryEntityQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [QuickCategoryAppEntity] {
        let objectIds = identifiers.compactMap { try? ObjectId(string: $0.id) }
        return await AppRealm.shared.getCategories { $0._id.in(objectIds) }
            .map { QuickCategoryAppEntity(id: $0.id, title: $0.title) }
    }

    func suggestedEntities() async throws -> [QuickCategoryAppEntity] {
//        CategoryEntity.random(count: 12)
        await AppRealm.shared.getAllArchivedCategories()
            .map { QuickCategoryAppEntity(id: $0.id, title: $0.title) }
    }

    func defaultResult() async -> QuickCategoryAppEntity? {
        try? await suggestedEntities().first
//        let entity = CategoryEntity.random()
//        return QuickCategoryAppEntity(id: entity.id, title: entity.title)
    }
}

struct QuickCategoryAppEntity: AppEntity {
    let id: String
    let title: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Categories"
    static var defaultQuery = QuickCategoryEntityQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}

@available(iOS 17.0, *)
struct QuickSelectCategoryConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Categories"

    @Parameter(title: "Categories")
    var categories: [QuickCategoryAppEntity]

    init(categories: [QuickCategoryAppEntity]) {
        self.categories = categories
    }

    init() {}
}

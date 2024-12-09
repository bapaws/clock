//
//  QuickConfigurationIntent.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/28.
//

import AppIntents
import Foundation
import HoursShare
import RealmSwift

struct QuickCategoryEntityQuery: EntityQuery {
    static var suggestedCategories: [QuickCategoryAppEntity]? = nil

    func entities(for identifiers: [String]) async throws -> [QuickCategoryAppEntity] {
        let objectIds = identifiers.compactMap { try? ObjectId(string: $0.id) }
        return await AppRealm.shared.getCategories { $0._id.in(objectIds) }
            .map { QuickCategoryAppEntity(id: $0.id, title: $0.title) }
    }

    func suggestedEntities() async throws -> [QuickCategoryAppEntity] {
        if let suggestedCategories = QuickCategoryEntityQuery.suggestedCategories {
            return suggestedCategories
        }
        QuickCategoryEntityQuery.suggestedCategories = await AppRealm.shared.getAllUnarchivedCategories(isContainsEvents: false)
            .map { QuickCategoryAppEntity(id: $0.id, title: $0.title) }
        return QuickCategoryEntityQuery.suggestedCategories!
    }

    func defaultResult() async -> QuickCategoryAppEntity? {
        return nil
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
struct QuickConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Categories"

    @Parameter(title: "Categories", default: [], size: [.systemMedium: 4, .systemLarge: 9])
    var categories: [QuickCategoryAppEntity]

    static var isDiscoverable: Bool { false }

    init(categories: [QuickCategoryAppEntity]) {
        self.categories = categories
    }

    init() {}
}

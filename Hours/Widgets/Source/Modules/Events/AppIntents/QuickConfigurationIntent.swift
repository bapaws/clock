//
//  QuickConfigurationIntent.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/28.
//

import AppIntents
import ClockShare
import Foundation
import HoursShare
import RealmSwift

// struct QuickCategoryEntityQuery: EntityQuery {
//    static var suggestedCategories: [QuickCategoryAppEntity]? = nil
//
//    func entities(for identifiers: [String]) async throws -> [QuickCategoryAppEntity] {
//        let objectIds = identifiers.compactMap { try? ObjectId(string: $0.id) }
//        return await AppRealm.shared.getCategories { $0._id.in(objectIds) }
//            .map { QuickCategoryAppEntity(id: $0.id, title: $0.title) }
//    }
//
//    func suggestedEntities() async throws -> [QuickCategoryAppEntity] {
//        if let suggestedCategories = QuickCategoryEntityQuery.suggestedCategories {
//            return suggestedCategories
//        }
//        QuickCategoryEntityQuery.suggestedCategories = await AppRealm.shared.getAllUnarchivedCategories(isContainsEvents: false)
//            .map { QuickCategoryAppEntity(id: $0.id, title: $0.title) }
//        return QuickCategoryEntityQuery.suggestedCategories!
//    }
//
//    func defaultResult() async -> QuickCategoryAppEntity? {
//        return nil
//    }
// }
//
// struct QuickCategoryAppEntity: AppEntity {
//    let id: String
//    let title: String
//
//    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Categories"
//    static var defaultQuery = QuickCategoryEntityQuery()
//
//    var displayRepresentation: DisplayRepresentation {
//        DisplayRepresentation(title: "\(title)")
//    }
// }
//
// @available(iOS 17.0, *)
// struct QuickConfigurationIntent: WidgetConfigurationIntent {
//    static var title: LocalizedStringResource = "Select Categories"
//
//    @Parameter(title: "Categories", default: [], size: [.systemMedium: 1, .systemLarge: 1])
//    var categories: [QuickCategoryAppEntity]
//
//    static var isDiscoverable: Bool { false }
//
//    init(categories: [QuickCategoryAppEntity]) {
//        self.categories = categories
//    }
//
//    init() {}
// }

// MARK: - Medium

struct QuickMediumWidgetEntityQuery: EntityQuery {
    init() {}

    func entities(for identifiers: [String]) async throws -> [QuickMediumWidgetEntity] {
        Storage.default.quickMediumWidgets?
            .filter { identifiers.contains($0.id) }
            .map { QuickMediumWidgetEntity(id: $0.id, title: $0.title) }
            ?? []
    }

    func suggestedEntities() async throws -> [QuickMediumWidgetEntity] {
        Storage.default.quickMediumWidgets?
            .map { QuickMediumWidgetEntity(id: $0.id, title: $0.title) } ?? []
    }

    func defaultResult() async -> QuickMediumWidgetEntity? {
        return nil
    }
}

struct QuickMediumWidgetEntity: AppEntity, Identifiable {
    var id: String
    var title: String

    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(stringLiteral: "Widget")
    }

    public static var defaultQuery = QuickMediumWidgetEntityQuery()

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}

@available(iOS 17.0, *)
struct QuickMediumConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Widget"

    @Parameter(title: "Widget")
    var widget: QuickMediumWidgetEntity?

    static var isDiscoverable: Bool { false }

    init(widget: QuickMediumWidgetEntity) {
        self.widget = widget
    }

    init() {}
}

// MARK: - Large

struct QuickLargeWidgetEntityQuery: EntityQuery {
    init() {}

    func entities(for identifiers: [String]) async throws -> [QuickLargeWidgetEntity] {
        Storage.default.quickLargeWidgets?
            .filter { identifiers.contains($0.id) }
            .map { QuickLargeWidgetEntity(id: $0.id, title: $0.title) }
            ?? []
    }

    func suggestedEntities() async throws -> [QuickLargeWidgetEntity] {
        Storage.default.quickLargeWidgets?
            .map { QuickLargeWidgetEntity(id: $0.id, title: $0.title) } ?? []
    }

    func defaultResult() async -> QuickLargeWidgetEntity? {
        return nil
    }
}

struct QuickLargeWidgetEntity: AppEntity, Identifiable {
    var id: String
    var title: String

    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(stringLiteral: "Widget")
    }

    public static var defaultQuery = QuickLargeWidgetEntityQuery()

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}

@available(iOS 17.0, *)
struct QuickLargeConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Widget"

    @Parameter(title: "Widget")
    var widget: QuickLargeWidgetEntity?

    static var isDiscoverable: Bool { false }

    init(widget: QuickLargeWidgetEntity) {
        self.widget = widget
    }

    init() {}
}

//
//  QuickSelectCategoryAppIntent.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/6.
//

import AppIntents
import ClockShare
import Foundation
import HoursShare
import WidgetKit

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct QuickSelectCategoryAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Select Category"
    static var description = IntentDescription("Select Category")

    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    static var isDiscoverable: Bool { return false }

    @Parameter(title: "widgetID")
    var widgetID: String

    @Parameter(title: "categoryID")
    var categoryID: String

    @Parameter(title: "familyRawValue")
    var familyRawValue: Int

    init() {}

    init(widgetID: String, categoryID: String, family: WidgetFamily) {
        self.widgetID = widgetID
        self.categoryID = categoryID
        self.familyRawValue = family.rawValue
    }

    func perform() async throws -> some IntentResult {
        guard let family = WidgetFamily(rawValue: familyRawValue) else { return .result() }

        switch family {
        case .systemMedium:
            if var widgets = Storage.default.quickMediumWidgets, let index = widgets.firstIndex(where: { $0.id == widgetID }) {
                widgets[index].selectedCategoryID = categoryID
                Storage.default.quickMediumWidgets = widgets
            }
        case .systemLarge:
            if var widgets = Storage.default.quickLargeWidgets, let index = widgets.firstIndex(where: { $0.id == widgetID }) {
                widgets[index].selectedCategoryID = categoryID
                Storage.default.quickLargeWidgets = widgets
            }
        default:
            break
        }

        return .result()
    }
}

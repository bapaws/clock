//
//  SelectCategoryAppIntent.swift
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
struct SelectCategoryAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Select Category"
    static var description = IntentDescription("Select Category")

    @Parameter(title: "CategoryID")
    var categoryID: String

    @Parameter(title: "familyRawValue")
    var familyRawValue: Int

    init() {}

    init(categoryID: String, family: WidgetFamily) {
        self.categoryID = categoryID
        self.familyRawValue = family.rawValue
    }

    func perform() async throws -> some IntentResult {
        guard let family = WidgetFamily(rawValue: familyRawValue) else { return .result() }

        switch family {
        case .systemMedium:
            Storage.default.mediumWidgetSelectedCategoryID = categoryID
        case .systemLarge:
            Storage.default.largeWidgetSelectedCategoryID = categoryID
        default:
            break
        }

        return .result()
    }
}

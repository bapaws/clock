//
//  Storage.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/6.
//

import ClockShare
import Foundation
import HoursShare

extension Storage {
//        public static let large = "Events.Large"
//        public static let medium = "Events.Medium"
    var largeWidgetSelectedCategoryID: String? {
        set { store.set(newValue, forKey: WidgetsKind.Quick.large) }
        get { store.string(forKey: WidgetsKind.Quick.large) }
    }

    var mediumWidgetSelectedCategoryID: String? {
        set { store.set(newValue, forKey: WidgetsKind.Quick.medium) }
        get { store.string(forKey: WidgetsKind.Quick.medium) }
    }
}

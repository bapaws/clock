//
//  File.swift
//
//
//  Created by 张敏超 on 2024/6/5.
//

import Foundation
import WidgetKit

public enum WidgetsKind {
    public static let scheme = "BapawsHours://bapaws.com"

    public static let widgetPath = "/widget"

    public enum Quick {
        public static let selectCategoryPath = WidgetsKind.scheme + WidgetsKind.widgetPath + "/select/category"
        public static let large = "Events.Large"
        public static let medium = "Events.Medium"

        public static var all: [String] {
            [large, medium]
        }
    }
}

public extension WidgetFamily {
    var quickMaxCategoryCount: Int {
        switch self {
        case .systemMedium: 4
        case .systemLarge: 8
        default: fatalError("Not support")
        }
    }

    var quickMaxEventCount: Int {
        switch self {
        case .systemMedium: 6
        case .systemLarge: 9
        default: fatalError("Not support")
        }
    }
}

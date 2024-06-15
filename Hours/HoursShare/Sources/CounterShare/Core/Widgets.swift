//
//  File.swift
//
//
//  Created by 张敏超 on 2024/6/5.
//

import Foundation

public enum WidgetsKind {
    public static let scheme = "BapawsHours://bapaws.com"

    public static let widgetPath = "/widget"

    public enum Events {
        public static let selectCategoryPath = WidgetsKind.scheme + WidgetsKind.widgetPath + "/select/category"
        public static let large = "Events.Large"
        public static let medium = "Events.Medium"

        public static var all: [String] {
            [large, medium]
        }
    }
}

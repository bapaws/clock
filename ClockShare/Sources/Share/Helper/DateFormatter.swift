//
//  DateFormatter.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/24.
//

import Foundation

extension DateFormatter {
    static let shared = DateFormatter()
}

public extension Date {
    func to(format: String, locale: String? = nil) -> String {
        let formatter = DateFormatter.shared
        if let locale = locale {
            formatter.locale = Locale(identifier: locale)
        } else {
            formatter.locale = Locale.current
        }
        formatter.setLocalizedDateFormatFromTemplate(format)
        return formatter.string(from: self)
    }
}

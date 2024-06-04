//
//  DateFormatter.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/24.
//

import Foundation
import SwiftDate

extension DateFormatter {
    static let shared = DateFormatter()
}

public extension Date {
    func to(format: String, locale: String? = nil) -> String {
        let formatter = DateFormatter.shared
        formatter.locale = SwiftDate.defaultRegion.locale
        formatter.setLocalizedDateFormatFromTemplate(format)
        return formatter.string(from: self)
    }
}

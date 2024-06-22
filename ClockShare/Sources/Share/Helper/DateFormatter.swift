//
//  DateFormatter.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/24.
//

import Foundation
import SwiftDate

public extension Date {
    func to(format: String, locale: String? = nil) -> String {
        let region = SwiftDate.defaultRegion
        let formatter = DateFormatter.sharedFormatter(forRegion: region)
        formatter.setLocalizedDateFormatFromTemplate(format)
        return formatter.string(from: self)
    }
}

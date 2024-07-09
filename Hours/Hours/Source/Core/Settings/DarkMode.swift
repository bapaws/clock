//
//  DarkMode.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/16.
//

import ClockShare

public extension DarkMode {
    static var title: String {
        L10n.darkMode
    }

    var value: String {
        switch self {
        case .light:
            L10n.light
        case .dark:
            L10n.dark
        default:
            L10n.modeAuto
        }
    }
}

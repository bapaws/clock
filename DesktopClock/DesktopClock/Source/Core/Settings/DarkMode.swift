//
//  DarkMode.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/16.
//

import ClockShare

public extension DarkMode {
    static var title: String {
        R.string.localizable.darkMode()
    }

    var value: String {
        switch self {
        case .light:
            R.string.localizable.light()
        case .dark:
            R.string.localizable.dark()
        default:
            R.string.localizable.modeAuto()
        }
    }
}

//
//  AppIcons.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import Foundation

public extension AppIconType {
    static var title: String {
        R.string.localizable.appIcon()
    }

    var value: String {
        switch self {
        case .lightClassic:
            R.string.localizable.lightClassic()
        case .lightPink:
            R.string.localizable.lightPink()
        case .lightOrange:
            R.string.localizable.lightOrange()
        case .lightPurple:
            R.string.localizable.lightPurple()
        case .darkClassic:
            R.string.localizable.darkClassic()
        case .darkPink:
            R.string.localizable.darkPink()
        case .darkOrange:
            R.string.localizable.darkOrange()
        case .darkPurple:
            R.string.localizable.darkPurple()
        }
    }
}

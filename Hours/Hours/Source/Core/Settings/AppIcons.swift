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
        case .darkClassic:
            R.string.localizable.darkClassic()
        default:
            fatalError("Not support")
        }
    }
}

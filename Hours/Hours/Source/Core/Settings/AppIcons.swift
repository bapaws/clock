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
        L10n.appIcon
    }

    var value: String {
        switch self {
        case .lightClassic:
            L10n.lightClassic
        case .darkClassic:
            L10n.darkClassic
        default:
            fatalError("Not support")
        }
    }
}

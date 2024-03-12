//
//  LandspaceMode.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/16.
//

import Foundation
import ClockShare

public extension LandspaceMode {
    static var title: String {
        R.string.localizable.landspaceMode()
    }

    var value: String {
        switch self {
        case .portrait:
            R.string.localizable.portrait()
        case .landspace:
            R.string.localizable.landspace()
        default:
            R.string.localizable.modeAuto()
        }
    }
}

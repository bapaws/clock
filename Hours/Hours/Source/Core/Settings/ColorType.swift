//
//  ColorType.swift
//  Hours
//
//  Created by 张敏超 on 2023/12/30.
//

import ClockShare
import SwiftUI

public extension ColorType {
    static var title: String {
        R.string.localizable.colorThemes()
    }

    var value: String {
        switch self {
        case .classic:
            R.string.localizable.classic()
        case .pink:
            R.string.localizable.pink()
        case .orange:
            R.string.localizable.orange()
        case .purple:
            R.string.localizable.purple()
        }
    }
}

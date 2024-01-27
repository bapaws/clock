//
//  DigitStyle.swift
//
//
//  Created by 张敏超 on 2024/1/21.
//

import ClockShare
import CoreFoundation

public extension DigitStyle {
    var heightMultiple: CGFloat {
        switch self {
        case .none:
            0
        case .small:
            0.35
        case .big:
            1
        }
    }

    var digitCount: CGFloat {
        switch self {
        case .none:
            0
        case .small:
            1
        case .big:
            1
        }
    }
}

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
        L10n.colorThemes
    }

    var value: String {
        switch self {
        case .classic:
            L10n.classic
        case .pink:
            L10n.pink
        case .orange:
            L10n.orange
        case .purple:
            L10n.purple
        }
    }
}

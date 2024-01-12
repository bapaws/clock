//
//  ColorType.swift
//
//
//  Created by 张敏超 on 2024/1/11.
//

import Foundation
import SwiftUI

public enum ColorType: String, CaseIterable, Codable {
    case classic, pink, orange, purple

    public var colors: Colors {
        switch self {
        case .classic:
            Colors.classic()
        case .pink:
            Colors.pink()
        case .orange:
            Colors.orange()
        case .purple:
            Colors.purple()
        }
    }

    public func colors(scheme: ColorScheme = .light) -> Colors {
        switch self {
        case .classic:
            Colors.classic(scheme: scheme)
        case .pink:
            Colors.pink(scheme: scheme)
        case .orange:
            Colors.orange(scheme: scheme)
        case .purple:
            Colors.purple(scheme: scheme)
        }
    }

    public var isPro: Bool {
        self != .classic
    }
}

//
//  DarkMode.swift
//
//
//  Created by 张敏超 on 2024/1/10.
//

import Foundation
import SwiftUI
import UIKit

public enum DarkMode: String, Codable, CaseIterable {
    case system, light, dark

    public var current: DarkMode {
        switch self {
        case .system:
            UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        default:
            self
        }
    }

    public var raw: ColorScheme? {
        switch self {
        case .light:
            .light
        case .dark:
            .dark
        default:
            nil
        }
    }

    public var style: UIUserInterfaceStyle {
        switch self {
        case .light:
            .light
        case .dark:
            .dark
        default:
            .unspecified
        }
    }
}

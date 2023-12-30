//
//  DarkMode.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/16.
//

import Foundation
import UIKit
import SwiftUI

public enum DarkMode: String, Codable, CaseIterable {
    case system, light, dark

    public static var title: String {
        R.string.localizable.darkMode()
    }

    public var value: String {
        switch self {
        case .light:
            R.string.localizable.light()
        case .dark:
            R.string.localizable.dark()
        default:
            R.string.localizable.modeAuto()
        }
    }

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

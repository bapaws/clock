//
//  AppIcons.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/1.
//

import Foundation

public enum AppIconType: String, CaseIterable {
    case darkClassic, lightClassic
    case lightPink, lightOrange, lightPurple
    case darkPink, darkOrange, darkPurple

    public static var title: String {
        R.string.localizable.appIcon()
    }

    public var value: String {
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

    public var imageName: String {
        switch self {
        case .lightClassic:
            "LightClassic"
        case .lightPink:
            "LightPink"
        case .lightOrange:
            "LightOrange"
        case .lightPurple:
            "LightPurple"
        case .darkClassic:
            "DarkClassic"
        case .darkPink:
            "DarkPink"
        case .darkOrange:
            "DarkOrange"
        case .darkPurple:
            "DarkPurple"
        }
    }

    public var iconName: String? {
        if let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let files = primary["CFBundleIconFiles"] as? [String],
           let icon = files.last
        {
            return icon
        }

        return nil
    }

    public var isPro: Bool {
        self != .lightClassic && self != .darkClassic
    }
}

//
//  AppIconType.swift
//
//
//  Created by 张敏超 on 2024/1/10.
//

import Foundation

public enum AppIconType: String, CaseIterable, Codable {
    case darkClassic, lightClassic
    case lightPink, lightOrange, lightPurple
    case darkPink, darkOrange, darkPurple

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
}

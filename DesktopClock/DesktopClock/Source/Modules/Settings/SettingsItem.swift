//
//  SettingsItem.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/26.
//

import Foundation

public struct SettingsItem: Identifiable {
    public enum CellType: Equatable, Identifiable, Hashable {
        case toggle(String, Bool)
        case popup(String, String?)
        case check(String, Bool)
//        case navigate(String, String?)

        public var id: String {
            switch self {
            case .toggle(let title, let bool):
                "toggle&\(title)&\(bool)"
            case .popup(let title, let string):
                "popup&\(title)&\(string ?? "")"
            case .check(let title, let bool):
                "check&\(title)&\(bool)"
//            case .navigate(let title, let string):
//                "navigate&\(title)&\(string ?? "")"
            }
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }

    public var type: CellType
    public var isPro: Bool = false
    public var action: (() -> Void)?

    public var id: String {
        type.id
    }
}

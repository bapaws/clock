//
//  LandspaceMode.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/16.
//

import Foundation
import UIKit
import SwiftUI

public enum LandspaceMode: String, Codable, CaseIterable {
    case system, portrait, landspace

    public static var title: String {
        R.string.localizable.landspaceMode()
    }

    public var value: String {
        switch self {
        case .portrait:
            R.string.localizable.portrait()
        case .landspace:
            R.string.localizable.landspace()
        default:
            R.string.localizable.modeAuto()
            
        }
    }

    public var current: LandspaceMode {
        switch self {
        case .system:
            UIScreen.main.bounds.width < UIScreen.main.bounds.height ? .portrait : .landspace
        default:
            self
        }
    }

    public var support: UIInterfaceOrientationMask {
        switch self {
        case .portrait:

            .portrait
        case .landspace:
            [.landscapeLeft, .landscapeRight]
        default:
            [.portrait, .landscapeLeft, .landscapeRight]
        }
    }

    public var preferred: UIInterfaceOrientationMask? {
        switch self {
        case .portrait:
            .portrait
        case .landspace:
            .landscapeRight
        default:
            nil
        }
    }
}

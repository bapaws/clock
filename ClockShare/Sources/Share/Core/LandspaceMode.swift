//
//  LandspaceMode.swift
//  
//
//  Created by 张敏超 on 2024/1/10.
//

import Foundation
import SwiftUI
import UIKit

public enum LandspaceMode: String, Codable, CaseIterable {
    case system, portrait, landspace

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

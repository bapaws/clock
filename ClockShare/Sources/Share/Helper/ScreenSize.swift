//
//  ScreenSize.swift
//
//
//  Created by 张敏超 on 2023/12/23.
//

import Dependencies
import Foundation
import SwiftUI

struct ScreenSizeKey: EnvironmentKey, DependencyKey {
    static var liveValue: CGSize = UIScreen.main.bounds.size

    static var defaultValue: CGSize {
        UIScreen.main.bounds.size
    }
}

// MARK: Environment

public extension EnvironmentValues {
    var screenSize: CGSize {
        self[ScreenSizeKey.self]
    }
}

// MARK: Dependency

public extension DependencyValues {
    var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
}

//
//  UIManager.swift
//  DeskClock
//
//  Created by 张敏超 on 2024/1/10.
//

import ClockShare
import Foundation
import SwiftUI
import UIKit
import WidgetKit

public class UIManager: ClockShare.UIBaseManager {
    public static let shared = UIManager()

    @Published public private(set) var colors: Colors = ColorType.classic.colors
    @AppStorage(Storage.Key.colorType, store: Storage.default.store)
    public var colorType: ColorType = .classic {
        didSet { setupColors() }
    }

    private init() {
        super.init(darkMode: .dark)
    }

    override public func setupUI() {
        super.setupUI()

        setupDarkMode()
        // pad 下横竖屏切换无效
        if UIDevice.current.userInterfaceIdiom != .pad {
            setupLandspaceMode()
        }

        setupNavigationBar()
    }

    override public func setupNavigationBar(_ navigationBar: UINavigationBar? = nil) {
        let classic = ColorType.classic.colors
        let backgroundColor = classic.background.toUIColor()
        let foregroundColor = classic.primary.toUIColor()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor: foregroundColor ?? UIColor.label
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 25, weight: .light),
            .foregroundColor: foregroundColor ?? UIColor.label
        ]
        let navigationBar = navigationBar ?? UINavigationBar.appearance()
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = foregroundColor
        navigationBar.barTintColor = foregroundColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    override public func setupColors(scheme: ColorScheme? = nil) {
        colors = colorType.colors
        colors.scheme = darkMode.current.raw ?? scheme ?? .light

        // 刷新小組件的樣式
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// MARK: - Color

public extension UIManager {
    var primary: Color { colors.primary }
    var secondary: Color { colors.secondary }
    var background: Color { colors.background }
    var darkShadow: Color { colors.darkShadow }
    var lightShadow: Color { colors.lightShadow }
}

// MARK: App Icon

extension UIManager {
    func changeAppIcon(to icon: AppIconType) {
        UIApplication.shared.setAlternateIconName(icon.imageName) { error in
            if let error = error {
                print("Error setting alternate icon \(error.localizedDescription)")
            }
        }
    }
}

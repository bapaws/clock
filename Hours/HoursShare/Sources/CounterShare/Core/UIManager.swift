//
//  UIManager.swift
//  DesktopClock
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

    public let bottomHeight: CGFloat = 54

    @Published public private(set) var colors: Colors = ColorType.classic.colors
    @AppStorage(Storage.Key.colorType, store: Storage.default.store)
    public var colorType: ColorType = .classic {
        didSet { setupColors() }
    }

    private init() {
        super.init(appIcon: .lightClassic)
    }

    override public func setupUI() {
        super.setupUI()

        setupDarkMode()
        // pad 下横竖屏切换无效
        if UIDevice.current.userInterfaceIdiom != .pad {
            setupLandspaceMode()
        }

        setupNavigationBar()
        setupTabBar()
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
            .font: UIFont.preferredFont(forTextStyle: .headline),
            .foregroundColor: foregroundColor ?? UIColor.label
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .title1),
            .foregroundColor: foregroundColor ?? UIColor.label
        ]
        let navigationBar = navigationBar ?? UINavigationBar.appearance()
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = foregroundColor
        navigationBar.barTintColor = foregroundColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    override public func setupTabBar(_ tabBar: UITabBar? = nil) {
        let classic = ColorType.classic.colors
        let backgroundColor = classic.background.toUIColor()
        let foregroundColor = classic.primary.toUIColor()

        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = backgroundColor
        let tabBar = tabBar ?? UITabBar.appearance()
        tabBar.tintColor = foregroundColor
        tabBar.barTintColor = foregroundColor
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
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
    var secondaryBackground: Color { colors.secondaryBackground }

    var label: Color { colors.label }
    var secondaryLabel: Color { colors.secondaryLabel }
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

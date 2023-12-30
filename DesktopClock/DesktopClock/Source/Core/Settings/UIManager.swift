//
//  UIManager.swift
//
//
//  Created by 张敏超 on 2023/12/23.
//

import ClockShare
import Foundation
import SwiftUI
import UIKit

public protocol IconStyle {
    var pomodoro: String { get }
    var clock: String { get }
    var timer: String { get }
    var settings: String { get }
    var start: String { get }
    var stop: String { get }
    var pause: String { get }
    var resume: String { get }

    var font: Font { get }
    var tabItemWidth: CGFloat { get }
    var tabItemHeight: CGFloat { get }
}

public class UIManager: ObservableObject {
    public static let shared = UIManager()

    @AppStorage(Storage.Key.darkMode, store: Storage.default.store)
    public var darkMode: DarkMode = .system {
        didSet {
            setupDarkMode()
        }
    }

    @AppStorage(Storage.Key.landspaceMode, store: Storage.default.store)
    public var landspaceMode: LandspaceMode = .system {
        didSet {
            setupLandspaceMode()
        }
    }

    @Published public private(set) var icon: IconStyle = TextIconStyle()

    @AppStorage(Storage.Key.iconType, store: Storage.default.store)
    public var iconType: IconType = .text {
        didSet { icon = iconType.style }
    }

    @Published public private(set) var color: ColorStyle = NeumorphicLightColors()

    @AppStorage(Storage.Key.colorType, store: Storage.default.store)
    public var colorType: ColorType = .light {
        didSet {
            color = colorType.style
            setupNavigationBar()
        }
    }

    private init() {}
}

// MARK: -

extension UIManager {
    func setupUI() {
        icon = iconType.style
        color = colorType.style

        setupNavigationBar()

        setupDarkMode()
        setupLandspaceMode()
    }

    func setupNavigationBar(_ navigationBar: UINavigationBar? = nil) {
        let backgroundColor = color.background.toUIColor()
        let foregroundColor = color.secondaryLabel.toUIColor()

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
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = foregroundColor
        navigationBar.barTintColor = foregroundColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    func setupDarkMode() {
        let windows = UIApplication.shared.connectedScenes.compactMap {
            $0 as? UIWindowScene
        }
        .flatMap {
            $0.windows
        }
        for window in windows {
            window.overrideUserInterfaceStyle = darkMode.style
        }
        // 刷新小組件的樣式
//            WidgetCenter.shared.reloadAllTimelines()
    }

    func setupLandspaceMode() {
        guard let preferred = landspaceMode.preferred else { return }

        if #available(iOS 16.0, *) {
            let windowScenes = UIApplication.shared.connectedScenes.compactMap {
                $0 as? UIWindowScene
            }
            for windowScene in windowScenes {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: preferred))

                for window in windowScene.windows {
                    window.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                }
            }
        } else {
            UIDevice.current.setValue(preferred.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

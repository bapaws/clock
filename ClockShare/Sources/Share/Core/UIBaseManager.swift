//
//  UIBaseManager.swift
//
//
//  Created by 张敏超 on 2023/12/23.
//

import Foundation
import SwiftUI
import UIKit
import WidgetKit

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

open class UIBaseManager: ObservableObject {
    public static let homeButtonSize = CGSize(width: 54, height: 54)

    @AppStorage(Storage.Key.appIcon, store: Storage.default.store)
    public var appIcon: AppIconType = .darkClassic {
        didSet { changeAppIcon(to: appIcon) }
    }

    @AppStorage(Storage.Key.darkMode, store: Storage.default.store)
    public var darkMode: DarkMode = .system {
        didSet {
            setupDarkMode()
            // 暗黑模式切换需要更换颜色
            setupColors()
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

    public init() {}

    // MARK: Setup

    open func setupUI() {
        icon = iconType.style
        setupColors()
    }

    open func setupNavigationBar(_ navigationBar: UINavigationBar? = nil) {}

    open func setupDarkMode() {
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
        WidgetCenter.shared.reloadAllTimelines()
    }

    open func setupLandspaceMode() {
        guard let preferred = landspaceMode.preferred else { return }

        if #available(iOS 16.0, *) {
            let windowScenes = UIApplication.shared.connectedScenes.compactMap {
                $0 as? UIWindowScene
            }
            for windowScene in windowScenes {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: preferred))

                for window in windowScene.windows {
                    window.rootViewController?.frontViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                }
            }
        } else {
            UIDevice.current.setValue(preferred.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }

    open func setupColors(scheme: ColorScheme? = nil) {
        // 刷新小組件的樣式
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// MARK: App Icon

extension UIBaseManager {
    func changeAppIcon(to icon: AppIconType) {
        UIApplication.shared.setAlternateIconName(icon.imageName) { error in
            if let error = error {
                print("Error setting alternate icon \(error.localizedDescription)")
            }
        }
    }
}

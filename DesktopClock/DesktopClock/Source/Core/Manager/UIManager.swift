//
//  UIManager.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/10.
//

import ClockShare
import Foundation
import UIKit

public extension UIManager {
    func setupAppUI() {
        setupUI()

        setupDarkMode()
        // pad 下横竖屏切换无效
        if UIDevice.current.userInterfaceIdiom != .pad {
            setupLandspaceMode()
        }

        setupNavigationBar()
    }
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

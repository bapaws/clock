//
//  UIViewController.swift
//
//
//  Created by 张敏超 on 2024/1/5.
//

import UIKit

public extension UIViewController {
    var frontViewController: UIViewController? {
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.frontViewController
        }
        if let tab = self as? UITabBarController, let selected = tab.selectedViewController {
            return selected.frontViewController
        }
        if let presented = presentedViewController {
            return presented.frontViewController
        }
        return self
    }
}

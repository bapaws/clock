//
//  UIApplication.swift
//
//
//  Created by 张敏超 on 2023/12/23.
//

import UIKit

public extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

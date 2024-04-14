//
//  UIApplication.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/11/13.
//

import UIKit

extension UIApplication {
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

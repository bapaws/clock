//
//  SafeArea.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/11.
//

import SwiftUI

extension UIApplication {
    var safeAreaInsets: EdgeInsets {
        keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

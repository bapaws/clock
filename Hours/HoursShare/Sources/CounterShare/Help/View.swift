//
//  File.swift
//
//
//  Created by 张敏超 on 2024/3/18.
//

import SwiftUI

public extension View {
    var ui: UIManager { UIManager.shared }

    var app: AppManager { AppManager.shared }
    var today: Date { app.today }

    func pushView<Destination: View>(_ content: Destination, title: String? = nil, animated: Bool = true) {
        UIApplication.shared.pushView(content, title: title, animated: animated)
    }

    func popView(animated: Bool = true) {
        UIApplication.shared.popView(animated: animated)
    }
}

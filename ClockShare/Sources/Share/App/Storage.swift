//
//  Storage.swift
//
//
//  Created by 张敏超 on 2023/12/24.
//

import Foundation

public class Storage {
    static let groupIdentifier = "group.com.bapaws.DesktopClock"
    public static let `default` = Storage()

    public enum Key {
        public static let purchasedProduct = "com.bapaws.iap.purchasedProduct"
        public static let launchedCount = "com.bapaws.launchedCount"

        public static let secondStyle = "secondStyle"
        public static let timeFormat = "timeFormat"
        public static let dateStyle = "dateStyle"

        public static let darkMode = "darkMode"
        public static let landspaceMode = "landspaceMode"
        public static let colorType = "colorType"
        public static let iconType = "iconType"

        public enum Pomodoro {
            public static let focusMinutes = "pomodoro.focusMinutes"
            public static let shortBreakMinutes = "pomodoro.shortBreakMinutes"
            public static let longBreakMinutes = "pomodoro.longBreakMinutes"
        }
    }

    public let store = UserDefaults(suiteName: Storage.groupIdentifier)
    public let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Storage.groupIdentifier)
}

public extension Storage {
    var launchedCount: Int {
        set { store?.set(newValue, forKey: Key.launchedCount) }
        get { store?.integer(forKey: Key.launchedCount) ?? 0 }
    }

    var purchasedProduct: PurchasedProduct? {
        set {
            if let value = newValue {
                let data = try? JSONEncoder().encode(value)
                store?.set(data, forKey: Key.purchasedProduct)
            } else {
                // 兼容 1.2.0 之前的版本
                store?.removeObject(forKey: Key.purchasedProduct)
            }
        }
        get {
            if let data = store?.data(forKey: Key.purchasedProduct) {
                return try? JSONDecoder().decode(PurchasedProduct.self, from: data)
            }
            return nil
        }
    }
}

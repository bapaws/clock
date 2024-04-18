//
//  Storage.swift
//
//
//  Created by 张敏超 on 2023/12/24.
//

import Foundation

public class Storage {
    static var groupIdentifier: String {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            return "group." + bundleIdentifier
        }
        return "group.com.bapaws.Clock"
    }

    public static let `default` = Storage()

    public enum Key {
        // MARK: Purchase

        public static let purchasedProduct = "com.bapaws.iap.purchasedProduct"

        // MARK: App

        public static let launchedCount = "com.bapaws.launchedCount"
        public static let soundType = "soundType"
        public static let isMute = "isMute"
        public static let idleTimerDisabled = "idleTimerDisabled"

        // MARK: Clock

        public static let secondStyle = "secondStyle"
        public static let timeFormat = "timeFormat"
        public static let dateStyle = "dateStyle"

        // MARK: Record

        public static let timingMode = "timingMode"
        public static let minimumRecordedTime = "minimumRecordedTime"
        public static let maximumRecordedTime = "maximumRecordedTime"

        // MARK: Timer

        public static let hourStyle = "hourStyle"

        // MARK: UI

        public static let appIcon = "appIcon"

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

    public let store = UserDefaults(suiteName: Storage.groupIdentifier) ?? UserDefaults.standard
    public let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Storage.groupIdentifier)

    public let group: UserDefaults? = UserDefaults(suiteName: Storage.groupIdentifier)
    public let standard: UserDefaults = .standard

    static var store: UserDefaults {
        `default`.group ?? `default`.standard
    }
}

public extension Storage {
    func data(forKey key: String) -> Data? {
        if let data = group?.data(forKey: key) {
            return data
        }
        // 1.0 的版本，由于代码封装错误，导致所有 groupID 错误，无法获取 group 的 UserDefaults
        // 从默认保存中获取存储值，保存到 group 中
        if let data = standard.data(forKey: key) {
            standard.removeObject(forKey: key)
            group?.set(data, forKey: key)
            return data
        }
        return nil
    }

    func string(forKey key: String) -> String? {
        if let string = group?.string(forKey: key) {
            return string
        }
        // 1.0 的版本，由于代码封装错误，导致所有 groupID 错误，无法获取 group 的 UserDefaults
        // 从默认保存中获取存储值，保存到 group 中
        if let string = standard.string(forKey: key) {
            standard.removeObject(forKey: key)
            group?.set(string, forKey: key)
            return string
        }
        return nil
    }

    func int(forKey key: String) -> Int {
        if let integer = group?.integer(forKey: key), integer != 0 {
            return integer
        }
        // 1.0 的版本，由于代码封装错误，导致所有 groupID 错误，无法获取 group 的 UserDefaults
        // 从默认保存中获取存储值，保存到 group 中
        let integer = standard.integer(forKey: key)
        if integer != 0 {
            standard.removeObject(forKey: key)
            group?.set(integer, forKey: key)
            return integer
        }
        return 0
    }

    func bool(forKey key: String) -> Bool {
        if let integer = group?.bool(forKey: key), integer {
            return integer
        }
        // 1.0 的版本，由于代码封装错误，导致所有 groupID 错误，无法获取 group 的 UserDefaults
        // 从默认保存中获取存储值，保存到 group 中
        let integer = standard.bool(forKey: key)
        if integer {
            standard.removeObject(forKey: key)
            group?.set(integer, forKey: key)
            return integer
        }
        return integer
    }
}

public extension Storage {
    var launchedCount: Int {
        set { store.set(newValue, forKey: Key.launchedCount) }
        get { store.integer(forKey: Key.launchedCount) }
    }

    var purchasedProduct: PurchasedProduct? {
        set {
            if let value = newValue {
                let data = try? JSONEncoder().encode(value)
                store.set(data, forKey: Key.purchasedProduct)
            } else {
                store.removeObject(forKey: Key.purchasedProduct)
            }
        }
        get {
            if let data = data(forKey: Key.purchasedProduct) {
                return try? JSONDecoder().decode(PurchasedProduct.self, from: data)
            }
            return nil
        }
    }

    var darkMode: DarkMode? {
        set {
            if let value = newValue?.rawValue {
                store.set(value, forKey: Key.darkMode)
            }
        }
        get {
            if let rawValue = string(forKey: Key.darkMode), let mode = DarkMode(rawValue: rawValue) {
                return mode
            }
            return nil
        }
    }

    var landspaceMode: LandspaceMode? {
        set {
            if let value = newValue?.rawValue {
                store.set(value, forKey: Key.landspaceMode)
            }
        }
        get {
            if let rawValue = string(forKey: Key.landspaceMode), let mode = LandspaceMode(rawValue: rawValue) {
                return mode
            }
            return nil
        }
    }

    var appIcon: AppIconType? {
        set {
            if let value = newValue?.rawValue {
                store.set(value, forKey: Key.appIcon)
            }
        }
        get {
            if let rawValue = string(forKey: Key.appIcon), let mode = AppIconType(rawValue: rawValue) {
                return mode
            }
            return nil
        }
    }
}

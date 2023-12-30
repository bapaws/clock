//
//  AppUUID.swift
//  Common
//
//  Created by 张敏超 on 2023/12/5.
//

import Foundation
import KeychainSwift

public class AppIdentifier {
    public static let shared = AppIdentifier()

    public let anonymous: String

    enum Key: String {
        case anonymous = "com.bapaws.uuid"
    }

    init() {
        anonymous = AppIdentifier.uuid(forKey: Key.anonymous)
    }

    static func uuid(forKey key: Key) -> String {
        uuid(forKey: key.rawValue)
    }
}

public extension AppIdentifier {
    static func uuid(forKey key: String) -> String {
        if let uuidString = UserDefaults.standard.string(forKey: key) {
            return uuidString
        }
        let keychain = KeychainSwift()
        if let anonymousInKeychain = keychain.get(key) {
            UserDefaults.standard.set(anonymousInKeychain, forKey: key)
            return anonymousInKeychain
        }
        let uuidString = UUID().uuidString
        UserDefaults.standard.set(uuidString, forKey: key)
        keychain.set(uuidString, forKey: key)
        return uuidString
    }
}

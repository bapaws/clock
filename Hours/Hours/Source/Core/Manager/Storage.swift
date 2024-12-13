//
//  File.swift
//
//
//  Created by 张敏超 on 2024/5/11.
//

import ClockShare
import Foundation
import HoursShare

extension Storage.Key {
    static let messageNotShowAgain = "messageNotShowAgain"
    static let messageShowLater = "messageShowLater"

    static let isReleaseVersion = "isReleaseVersion"
    static let appStoreVersion = "appStoreVersion"
}

extension Storage {
    func messageIsNotShowAgain(_ message: MessageItem) -> Bool {
        return store.bool(forKey: "\(Key.messageNotShowAgain)_\(message.id)")
    }

    func notShowAgain(message: MessageItem) {
        store.set(true, forKey: "\(Key.messageNotShowAgain)_\(message.id)")
    }

    func messageWillShowAt(_ message: MessageItem) -> Date? {
        return store.value(forKey: "\(Key.messageShowLater)_\(message.id)") as? Date
    }

    func willShow(message: MessageItem, at date: Date?) {
        let key = "\(Key.messageShowLater)_\(message.id)"
        if let date {
            store.set(date, forKey: key)
        } else {
            store.removeObject(forKey: key)
        }
    }

    var isReleaseVersion: Bool {
        set {
            store.set(newValue, forKey: Key.isReleaseVersion)
        }
        get {
            store.bool(forKey: Key.isReleaseVersion)
        }
    }

    var appStoreVersion: String? {
        set {
            store.set(newValue, forKey: Key.appStoreVersion)
        }
        get {
            store.string(forKey: Key.appStoreVersion)
        }
    }
}

//
//  File.swift
//
//
//  Created by 张敏超 on 2024/5/11.
//

import ClockShare
import Foundation

public extension Storage.Key {
    static let hexIndex = "hexIndex"
}

public extension Storage {
    var hexIndex: Int? {
        set {
            if let index = newValue {
                store.set(index, forKey: Key.hexIndex)
            } else {
                store.removeObject(forKey: Key.hexIndex)
            }
        }
        get {
            store.object(forKey: Key.hexIndex) as? Int
        }
    }
}

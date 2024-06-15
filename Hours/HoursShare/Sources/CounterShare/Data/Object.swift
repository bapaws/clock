//
//  File.swift
//
//
//  Created by 张敏超 on 2024/6/1.
//

import Foundation
import RealmSwift

public protocol Entity: Identifiable, Equatable, Codable {
    associatedtype Object = RealmSwift.Object
    var _id: ObjectId { get }

    init(object: Object, isLinkedObject: Bool)
    func toObject() -> Object

    static func random(count: Int) -> [Self]
}

public extension Entity {
    var id: String { _id.stringValue }

    static func random() -> Self {
        random(count: 1)[0]
    }

    static func randomEmoji() -> String {
        let emojiRange = 0x1F600 ... 0x1F64F
        let randomValue = Int.random(in: emojiRange)
        return String(UnicodeScalar(randomValue)!)
    }
}

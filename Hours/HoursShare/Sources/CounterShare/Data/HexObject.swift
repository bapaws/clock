//
//  Task.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/8.
//

import ClockShare
import Foundation
import RealmSwift
import SwiftUI

public class HexObject: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted public var light: String
    @Persisted public var dark: String

    public lazy var color: Color = .init(hexadecimal: light)
    public lazy var titleColor: Color = .init(uiColor: UIColor(hexadecimal: light).titleColor(black: .init(white: 0.2, alpha: 1)))
    public lazy var subtitleColor: Color = .init(uiColor: UIColor(hexadecimal: light).titleColor(black: .darkGray, white: .init(white: 0.9, alpha: 1.0)))

    override public init() {
        super.init()
    }

    public init(light: String, dark: String) {
        super.init()

        self._id = ObjectId.generate()
        self.light = light
        self.dark = dark
    }

    public init(hex: String) {
        super.init()

        self._id = ObjectId.generate()
        self.light = hex
        self.dark = hex
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case light
        case dark
    }

    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.light = try container.decode(String.self, forKey: .light)
        self.dark = try container.decode(String.self, forKey: .dark)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(light, forKey: .light)
        try container.encode(dark, forKey: .dark)
    }
}

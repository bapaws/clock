//
//  Task.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/8.
//

import ClockShare
import Foundation
import Palette
import RealmSwift
import SwiftUI
import SwiftUIX

public class HexObject: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var rgb: Int
    @Persisted var light: SchemeObject?
    @Persisted var dark: SchemeObject?

    override public init() {
        super.init()
    }

    public init(rgb: Int) {
        super.init()

        self._id = ObjectId.generate()
        self.rgb = rgb
        self.light = SchemeObject(scheme: Scheme.light(argb: rgb))
        self.dark = SchemeObject(scheme: Scheme.dark(argb: rgb))
    }

    public convenience init(hex: String) {
        self.init(rgb: Int(hex: hex))
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case rgb
        case light
        case dark
    }

    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rgb = try container.decode(Int.self, forKey: .rgb)
        self.light = try container.decode(SchemeObject.self, forKey: .light)
        self.dark = try container.decode(SchemeObject.self, forKey: .dark)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rgb, forKey: .rgb)
        try container.encode(light, forKey: .light)
        try container.encode(dark, forKey: .dark)
    }
}

// MARK: Color

public extension HexObject {
    var color: Color { Color(rgb: rgb) }

    var primary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.primary : self.light!.primary) })
    }

    var onPrimary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onPrimary : self.light!.onPrimary) })
    }

    var primaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.primaryContainer : self.light!.primaryContainer) })
    }

    var onPrimaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onPrimaryContainer : self.light!.onPrimaryContainer) })
    }

    var secondary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.secondary : self.light!.secondary) })
    }

    var onSecondary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onSecondary : self.light!.onSecondary) })
    }

    var secondaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.secondaryContainer : self.light!.secondaryContainer) })
    }

    var onSecondaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onSecondaryContainer : self.light!.onSecondaryContainer) })
    }

    var tertiary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.tertiary : self.light!.tertiary) })
    }

    var onTertiary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onTertiary : self.light!.onTertiary) })
    }

    var tertiaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.tertiaryContainer : self.light!.tertiaryContainer) })
    }

    var onTertiaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onTertiaryContainer : self.light!.onTertiaryContainer) })
    }

    var error: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.error : self.light!.error) })
    }

    var onError: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onError : self.light!.onError) })
    }

    var errorContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.errorContainer : self.light!.errorContainer) })
    }

    var onErrorContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onErrorContainer : self.light!.onErrorContainer) })
    }

    var background: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.background : self.light!.background) })
    }

    var onBackground: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onBackground : self.light!.onBackground) })
    }

    var surface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.surface : self.light!.surface) })
    }

    var onSurface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onSurface : self.light!.onSurface) })
    }

    var surfaceVariant: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.surfaceVariant : self.light!.surfaceVariant) })
    }

    var onSurfaceVariant: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onSurfaceVariant : self.light!.onSurfaceVariant) })
    }

    var outline: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.outline : self.light!.outline) })
    }

    var outlineVariant: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.outlineVariant : self.light!.outlineVariant) })
    }

    var shadow: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.shadow : self.light!.shadow) })
    }

    var scrim: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.scrim : self.light!.scrim) })
    }

    var inverseSurface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.inverseSurface : self.light!.inverseSurface) })
    }

    var onInverseSurface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onInverseSurface : self.light!.onInverseSurface) })
    }

    var inversePrimary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.inversePrimary : self.light!.inversePrimary) })
    }

    static var random: HexObject {
        HexObject(rgb: UIColor.random.argb)
    }
}

// MARK: Hex

public struct HexEntity: Entity {
    public let _id: ObjectId

    private var rgb: Int
    var light: SchemeEntity?
    var dark: SchemeEntity?

    public init(rgb: Int) {
        self._id = .generate()
        self.rgb = rgb
        self.light = SchemeEntity(scheme: Scheme.light(argb: rgb))
        self.dark = SchemeEntity(scheme: Scheme.dark(argb: rgb))
    }

    public init(hex: String) {
        self.init(rgb: Int(hex: hex))
    }

    // MARK: Entity

    public init(object: HexObject, isLinkedObject: Bool = false) {
        self._id = object._id
        self.rgb = object.rgb
        if let light = object.light {
            self.light = SchemeEntity(object: light)
        }
        if let dark = object.dark {
            self.dark = SchemeEntity(object: dark)
        }
    }

    public func toObject() -> HexObject {
        let object = HexObject()
        object._id = .generate()
        object.rgb = rgb
        object.light = light?.toObject()
        object.dark = dark?.toObject()
        return object
    }

    public static func random(count: Int) -> [Self] {
        var entities = [Self]()
        for _ in 0 ..< count {
            let red = arc4random_uniform(256)
            let green = arc4random_uniform(256)
            let blue = arc4random_uniform(256)
            let hex = String(format: "#%02X%02X%02X", red, green, blue)
            entities.append(HexEntity(hex: hex))
        }
        return entities
    }
}

// MARK: Color

public extension HexEntity {
    var color: Color { Color(rgb: rgb) }

    var primary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.primary : self.light!.primary) })
    }

    var onPrimary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onPrimary : self.light!.onPrimary) })
    }

    var primaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.primaryContainer : self.light!.primaryContainer) })
    }

    var onPrimaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onPrimaryContainer : self.light!.onPrimaryContainer) })
    }

    var secondary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.secondary : self.light!.secondary) })
    }

    var onSecondary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onSecondary : self.light!.onSecondary) })
    }

    var secondaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.secondaryContainer : self.light!.secondaryContainer) })
    }

    var onSecondaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onSecondaryContainer : self.light!.onSecondaryContainer) })
    }

    var tertiary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.tertiary : self.light!.tertiary) })
    }

    var onTertiary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onTertiary : self.light!.onTertiary) })
    }

    var tertiaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.tertiaryContainer : self.light!.tertiaryContainer) })
    }

    var onTertiaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onTertiaryContainer : self.light!.onTertiaryContainer) })
    }

    var error: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.error : self.light!.error) })
    }

    var onError: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onError : self.light!.onError) })
    }

    var errorContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.errorContainer : self.light!.errorContainer) })
    }

    var onErrorContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onErrorContainer : self.light!.onErrorContainer) })
    }

    var background: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.background : self.light!.background) })
    }

    var onBackground: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onBackground : self.light!.onBackground) })
    }

    var surface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.surface : self.light!.surface) })
    }

    var onSurface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onSurface : self.light!.onSurface) })
    }

    var surfaceVariant: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.surfaceVariant : self.light!.surfaceVariant) })
    }

    var onSurfaceVariant: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onSurfaceVariant : self.light!.onSurfaceVariant) })
    }

    var outline: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.outline : self.light!.outline) })
    }

    var outlineVariant: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.outlineVariant : self.light!.outlineVariant) })
    }

    var shadow: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.shadow : self.light!.shadow) })
    }

    var scrim: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.scrim : self.light!.scrim) })
    }

    var inverseSurface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.inverseSurface : self.light!.inverseSurface) })
    }

    var onInverseSurface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.onInverseSurface : self.light!.onInverseSurface) })
    }

    var inversePrimary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark!.inversePrimary : self.light!.inversePrimary) })
    }

    static var random: HexEntity {
        HexEntity(rgb: UIColor.random.argb)
    }
}

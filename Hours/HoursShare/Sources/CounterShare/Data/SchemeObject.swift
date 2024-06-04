//
//  SchemeObject.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/15.
//

import Foundation
import Palette
import RealmSwift

class SchemeObject: Object, ObjectKeyIdentifiable, Codable {
    @Persisted var primary: Int
    @Persisted var onPrimary: Int
    @Persisted var primaryContainer: Int
    @Persisted var onPrimaryContainer: Int
    @Persisted var secondary: Int
    @Persisted var onSecondary: Int
    @Persisted var secondaryContainer: Int
    @Persisted var onSecondaryContainer: Int
    @Persisted var tertiary: Int
    @Persisted var onTertiary: Int
    @Persisted var tertiaryContainer: Int
    @Persisted var onTertiaryContainer: Int
    @Persisted var error: Int
    @Persisted var onError: Int
    @Persisted var errorContainer: Int
    @Persisted var onErrorContainer: Int
    @Persisted var background: Int
    @Persisted var onBackground: Int
    @Persisted var surface: Int
    @Persisted var onSurface: Int
    @Persisted var surfaceVariant: Int
    @Persisted var onSurfaceVariant: Int
    @Persisted var outline: Int
    @Persisted var outlineVariant: Int
    @Persisted var shadow: Int
    @Persisted var scrim: Int
    @Persisted var inverseSurface: Int
    @Persisted var onInverseSurface: Int
    @Persisted var inversePrimary: Int

    override public init() {
        super.init()
    }

    init(scheme: Scheme) {
        self.primary = scheme.primary
        self.onPrimary = scheme.onPrimary
        self.primaryContainer = scheme.primaryContainer
        self.onPrimaryContainer = scheme.onPrimaryContainer
        self.secondary = scheme.secondary
        self.onSecondary = scheme.onSecondary
        self.secondaryContainer = scheme.secondaryContainer
        self.onSecondaryContainer = scheme.onSecondaryContainer
        self.tertiary = scheme.tertiary
        self.onTertiary = scheme.onTertiary
        self.tertiaryContainer = scheme.tertiaryContainer
        self.onTertiaryContainer = scheme.onTertiaryContainer
        self.error = scheme.error
        self.onError = scheme.onError
        self.errorContainer = scheme.errorContainer
        self.onErrorContainer = scheme.onErrorContainer
        self.background = scheme.background
        self.onBackground = scheme.onBackground
        self.surface = scheme.surface
        self.onSurface = scheme.onSurface
        self.surfaceVariant = scheme.surfaceVariant
        self.onSurfaceVariant = scheme.onSurfaceVariant
        self.outline = scheme.outline
        self.outlineVariant = scheme.outlineVariant
        self.shadow = scheme.shadow
        self.scrim = scheme.scrim
        self.inverseSurface = scheme.inverseSurface
        self.onInverseSurface = scheme.onInverseSurface
        self.inversePrimary = scheme.inversePrimary
    }

    // MAKR: Codable

    enum CodingKeys: CodingKey {
        case primary
        case onPrimary
        case primaryContainer
        case onPrimaryContainer
        case secondary
        case onSecondary
        case secondaryContainer
        case onSecondaryContainer
        case tertiary
        case onTertiary
        case tertiaryContainer
        case onTertiaryContainer
        case error
        case onError
        case errorContainer
        case onErrorContainer
        case background
        case onBackground
        case surface
        case onSurface
        case surfaceVariant
        case onSurfaceVariant
        case outline
        case outlineVariant
        case shadow
        case scrim
        case inverseSurface
        case onInverseSurface
        case inversePrimary
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.primary = try container.decode(Int.self, forKey: .primary)
        self.onPrimary = try container.decode(Int.self, forKey: .onPrimary)
        self.primaryContainer = try container.decode(Int.self, forKey: .primaryContainer)
        self.onPrimaryContainer = try container.decode(Int.self, forKey: .onPrimaryContainer)
        self.secondary = try container.decode(Int.self, forKey: .secondary)
        self.onSecondary = try container.decode(Int.self, forKey: .onSecondary)
        self.secondaryContainer = try container.decode(Int.self, forKey: .secondaryContainer)
        self.onSecondaryContainer = try container.decode(Int.self, forKey: .onSecondaryContainer)
        self.tertiary = try container.decode(Int.self, forKey: .tertiary)
        self.onTertiary = try container.decode(Int.self, forKey: .onTertiary)
        self.tertiaryContainer = try container.decode(Int.self, forKey: .tertiaryContainer)
        self.onTertiaryContainer = try container.decode(Int.self, forKey: .onTertiaryContainer)
        self.error = try container.decode(Int.self, forKey: .error)
        self.onError = try container.decode(Int.self, forKey: .onError)
        self.errorContainer = try container.decode(Int.self, forKey: .errorContainer)
        self.onErrorContainer = try container.decode(Int.self, forKey: .onErrorContainer)
        self.background = try container.decode(Int.self, forKey: .background)
        self.onBackground = try container.decode(Int.self, forKey: .onBackground)
        self.surface = try container.decode(Int.self, forKey: .surface)
        self.onSurface = try container.decode(Int.self, forKey: .onSurface)
        self.surfaceVariant = try container.decode(Int.self, forKey: .surfaceVariant)
        self.onSurfaceVariant = try container.decode(Int.self, forKey: .onSurfaceVariant)
        self.outline = try container.decode(Int.self, forKey: .outline)
        self.outlineVariant = try container.decode(Int.self, forKey: .outlineVariant)
        self.shadow = try container.decode(Int.self, forKey: .shadow)
        self.scrim = try container.decode(Int.self, forKey: .scrim)
        self.inverseSurface = try container.decode(Int.self, forKey: .inverseSurface)
        self.onInverseSurface = try container.decode(Int.self, forKey: .onInverseSurface)
        self.inversePrimary = try container.decode(Int.self, forKey: .inversePrimary)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.primary, forKey: .primary)
        try container.encode(self.onPrimary, forKey: .onPrimary)
        try container.encode(self.primaryContainer, forKey: .primaryContainer)
        try container.encode(self.onPrimaryContainer, forKey: .onPrimaryContainer)
        try container.encode(self.secondary, forKey: .secondary)
        try container.encode(self.onSecondary, forKey: .onSecondary)
        try container.encode(self.secondaryContainer, forKey: .secondaryContainer)
        try container.encode(self.onSecondaryContainer, forKey: .onSecondaryContainer)
        try container.encode(self.tertiary, forKey: .tertiary)
        try container.encode(self.onTertiary, forKey: .onTertiary)
        try container.encode(self.tertiaryContainer, forKey: .tertiaryContainer)
        try container.encode(self.onTertiaryContainer, forKey: .onTertiaryContainer)
        try container.encode(self.error, forKey: .error)
        try container.encode(self.onError, forKey: .onError)
        try container.encode(self.errorContainer, forKey: .errorContainer)
        try container.encode(self.onErrorContainer, forKey: .onErrorContainer)
        try container.encode(self.background, forKey: .background)
        try container.encode(self.onBackground, forKey: .onBackground)
        try container.encode(self.surface, forKey: .surface)
        try container.encode(self.onSurface, forKey: .onSurface)
        try container.encode(self.surfaceVariant, forKey: .surfaceVariant)
        try container.encode(self.onSurfaceVariant, forKey: .onSurfaceVariant)
        try container.encode(self.outline, forKey: .outline)
        try container.encode(self.outlineVariant, forKey: .outlineVariant)
        try container.encode(self.shadow, forKey: .shadow)
        try container.encode(self.scrim, forKey: .scrim)
        try container.encode(self.inverseSurface, forKey: .inverseSurface)
        try container.encode(self.onInverseSurface, forKey: .onInverseSurface)
        try container.encode(self.inversePrimary, forKey: .inversePrimary)
    }
}

// MARK: Entity

struct SchemeEntity: Entity {
    var _id: ObjectId = .generate()

    var primary: Int
    var onPrimary: Int
    var primaryContainer: Int
    var onPrimaryContainer: Int
    var secondary: Int
    var onSecondary: Int
    var secondaryContainer: Int
    var onSecondaryContainer: Int
    var tertiary: Int
    var onTertiary: Int
    var tertiaryContainer: Int
    var onTertiaryContainer: Int
    var error: Int
    var onError: Int
    var errorContainer: Int
    var onErrorContainer: Int
    var background: Int
    var onBackground: Int
    var surface: Int
    var onSurface: Int
    var surfaceVariant: Int
    var onSurfaceVariant: Int
    var outline: Int
    var outlineVariant: Int
    var shadow: Int
    var scrim: Int
    var inverseSurface: Int
    var onInverseSurface: Int
    var inversePrimary: Int

    init(object: SchemeObject, isLinkedObject: Bool = false) {
        self.primary = object.primary
        self.onPrimary = object.onPrimary
        self.primaryContainer = object.primaryContainer
        self.onPrimaryContainer = object.onPrimaryContainer
        self.secondary = object.secondary
        self.onSecondary = object.onSecondary
        self.secondaryContainer = object.secondaryContainer
        self.onSecondaryContainer = object.onSecondaryContainer
        self.tertiary = object.tertiary
        self.onTertiary = object.onTertiary
        self.tertiaryContainer = object.tertiaryContainer
        self.onTertiaryContainer = object.onTertiaryContainer
        self.error = object.error
        self.onError = object.onError
        self.errorContainer = object.errorContainer
        self.onErrorContainer = object.onErrorContainer
        self.background = object.background
        self.onBackground = object.onBackground
        self.surface = object.surface
        self.onSurface = object.onSurface
        self.surfaceVariant = object.surfaceVariant
        self.onSurfaceVariant = object.onSurfaceVariant
        self.outline = object.outline
        self.outlineVariant = object.outlineVariant
        self.shadow = object.shadow
        self.scrim = object.scrim
        self.inverseSurface = object.inverseSurface
        self.onInverseSurface = object.onInverseSurface
        self.inversePrimary = object.inversePrimary
    }

    init(scheme: Scheme) {
        self.primary = scheme.primary
        self.onPrimary = scheme.onPrimary
        self.primaryContainer = scheme.primaryContainer
        self.onPrimaryContainer = scheme.onPrimaryContainer
        self.secondary = scheme.secondary
        self.onSecondary = scheme.onSecondary
        self.secondaryContainer = scheme.secondaryContainer
        self.onSecondaryContainer = scheme.onSecondaryContainer
        self.tertiary = scheme.tertiary
        self.onTertiary = scheme.onTertiary
        self.tertiaryContainer = scheme.tertiaryContainer
        self.onTertiaryContainer = scheme.onTertiaryContainer
        self.error = scheme.error
        self.onError = scheme.onError
        self.errorContainer = scheme.errorContainer
        self.onErrorContainer = scheme.onErrorContainer
        self.background = scheme.background
        self.onBackground = scheme.onBackground
        self.surface = scheme.surface
        self.onSurface = scheme.onSurface
        self.surfaceVariant = scheme.surfaceVariant
        self.onSurfaceVariant = scheme.onSurfaceVariant
        self.outline = scheme.outline
        self.outlineVariant = scheme.outlineVariant
        self.shadow = scheme.shadow
        self.scrim = scheme.scrim
        self.inverseSurface = scheme.inverseSurface
        self.onInverseSurface = scheme.onInverseSurface
        self.inversePrimary = scheme.inversePrimary
    }

    static func random(count: Int) -> [SchemeEntity] {
        var entities = [Self]()
        for _ in 0 ..< count {
            let red = arc4random_uniform(256)
            let green = arc4random_uniform(256)
            let blue = arc4random_uniform(256)
            let hex = String(format: "#FF%02X%02X%02X", red, green, blue)
            let scheme = Scheme.dark(argb: Int(hex: hex))
            entities.append(SchemeEntity(scheme: scheme))
        }
        return entities
    }
}

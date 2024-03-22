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

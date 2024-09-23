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
    @Persisted(primaryKey: true) var _id: ObjectId

    /// CKRecordConvertible & CKRecordRecoverable
    @Persisted public var deletedAt: Date?

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

    @Persisted var linkingObjectID: String?

    override public init() {
        super.init()
    }

    init(scheme: Scheme) {
        super.init()
        self._id = .generate()
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
}

// MARK: Entity

struct SchemeEntity: Entity {
    var _id: ObjectId

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

    var deletedAt: Date?
    var linkingObjectID: String?

    init(scheme: Scheme) {
        self._id = .generate()
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

    // MARK: Entity

    init(object: SchemeObject, isLinkedObject: Bool = false) {
        self._id = object._id
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
        self.deletedAt = object.deletedAt
        self.linkingObjectID = object.linkingObjectID
    }

    func toObject() -> SchemeObject {
        let object = SchemeObject()
        object._id = _id
        object.primary = primary
        object.onPrimary = onPrimary
        object.primaryContainer = primaryContainer
        object.onPrimaryContainer = onPrimaryContainer
        object.secondary = secondary
        object.onSecondary = onSecondary
        object.secondaryContainer = secondaryContainer
        object.onSecondaryContainer = onSecondaryContainer
        object.tertiary = tertiary
        object.onTertiary = onTertiary
        object.tertiaryContainer = tertiaryContainer
        object.onTertiaryContainer = onTertiaryContainer
        object.error = error
        object.onError = onError
        object.errorContainer = errorContainer
        object.onErrorContainer = onErrorContainer
        object.background = background
        object.onBackground = onBackground
        object.surface = surface
        object.onSurface = onSurface
        object.surfaceVariant = surfaceVariant
        object.onSurfaceVariant = onSurfaceVariant
        object.outline = outline
        object.outlineVariant = outlineVariant
        object.shadow = shadow
        object.scrim = scrim
        object.inverseSurface = inverseSurface
        object.onInverseSurface = onInverseSurface
        object.inversePrimary = inversePrimary
        object.deletedAt = deletedAt
        object.linkingObjectID = linkingObjectID
        return object
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

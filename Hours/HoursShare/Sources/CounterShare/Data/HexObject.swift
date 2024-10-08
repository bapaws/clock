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

    @Persisted public var linkingObjectID: String?

    /// CKRecordConvertible & CKRecordRecoverable
    @Persisted public var deletedAt: Date? {
        didSet {
            light?.deletedAt = deletedAt
            dark?.deletedAt = deletedAt
        }
    }

    override public init() {
        super.init()
    }

    public init(rgb: Int) {
        super.init()

        self._id = ObjectId.generate()
        self.rgb = rgb
        self.light = SchemeObject(scheme: Scheme.light(argb: rgb))
        light?.linkingObjectID = _id.stringValue
        self.dark = SchemeObject(scheme: Scheme.dark(argb: rgb))
        dark?.linkingObjectID = _id.stringValue
    }

    public convenience init(hex: String) {
        self.init(rgb: Int(hex: hex))
    }
}

// MARK: Hex

public struct HexEntity: Entity {
    public let _id: ObjectId

    public private(set) var rgb: Int
    var light: SchemeEntity
    var dark: SchemeEntity

    public var deletedAt: Date?
    var linkingObjectID: String?

    public init(rgb: Int) {
        self._id = .generate()
        self.rgb = rgb
        self.light = SchemeEntity(scheme: Scheme.light(argb: rgb))
        self.dark = SchemeEntity(scheme: Scheme.dark(argb: rgb))
    }

    public init(hex: String) {
        self.init(rgb: Int(hex: hex))
    }

    public init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        let red = Int(red * 255) << 16 & 0xFF0000
        let green = Int(green * 255) << 8 & 0xFF00
        let blue = Int(blue * 255) & 0xFF
        self.init(rgb: red | green | blue)
    }

    // MARK: Entity

    public init(object: HexObject, isLinkedObject: Bool = false) {
        self._id = object._id
        self.rgb = object.rgb
        if let light = object.light {
            self.light = SchemeEntity(object: light)
        } else {
#if DEBUG
            /// 1.7.7 之前的版本中，存在数据关联错误的问题，颜色数据最明显
            /// 非 DEBUG 模式下，用下面的代码可以直接修复问题
            self.light = HexEntity.default.light
#else
            self.light = SchemeEntity(scheme: Scheme.light(argb: object.rgb))
#endif
        }
        if let dark = object.dark {
            self.dark = SchemeEntity(object: dark)
        } else {
#if DEBUG
            self.dark = HexEntity.default.dark
#else
            self.dark = SchemeEntity(scheme: Scheme.dark(argb: object.rgb))
#endif
        }
        self.linkingObjectID = object.linkingObjectID
    }

    public func toObject() -> HexObject {
        let object = HexObject()
        object._id = _id
        object.rgb = rgb
        object.light = light.toObject()
        object.light?.linkingObjectID = id
        object.dark = dark.toObject()
        object.dark?.linkingObjectID = id
        object.linkingObjectID = linkingObjectID
        return object
    }

    public static func random(count: Int) -> [Self] {
        var entities = [Self]()
        for _ in 0..<count {
            let red = arc4random_uniform(256)
            let green = arc4random_uniform(256)
            let blue = arc4random_uniform(256)
            let hex = String(format: "#%02X%02X%02X", red, green, blue)
            entities.append(HexEntity(hex: hex))
        }
        return entities
    }

    public static let `default` = HexEntity(rgb: 0xFF000000)

    public var red: CGFloat { CGFloat(rgb >> 16 & 0xFF) / 255 }
    public var green: CGFloat { CGFloat(rgb >> 8 & 0xFF) / 255 }
    public var blue: CGFloat { CGFloat(rgb & 0xFF) / 255 }
}

// MARK: Color

public extension HexEntity {
    static var random: HexEntity {
        let red: CGFloat = .random(in: 0 ... 1)
        let green: CGFloat = .random(in: 0 ... 1)
        let blue: CGFloat = .random(in: 0 ... 1)
        return HexEntity(red: red, green: green, blue: blue)
    }
}

// MARK: HSB

public extension HexEntity {
    enum HueCategory: Int, CaseIterable, Hashable {
        case red
        case orange
        case yellow
        case green
//        case cyan
        case blue
        case purple

        public var hueRange: Range<Int> {
            switch self {
            case .red: -30..<30
            case .orange: 30..<60
            case .yellow: 60..<90
//            case .green: 90..<150
//            case .cyan: 150..<210
            case .green: 90..<210
            case .blue: 210..<270
            case .purple: 270..<330
            }
        }

        public init(uiColor: UIColor) {
            var hue: CGFloat = 0
            uiColor.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
            let normalizedHue = hue.truncatingRemainder(dividingBy: 1) * 360 - 30
            switch normalizedHue {
            case -30..<30: self = .red
            case 30..<60: self = .orange
            case 60..<90: self = .yellow
//            case 90..<150: self = .green
//            case 150..<210: self = .cyan
            case 90..<210: self = .green
            case 210..<270: self = .blue
            case 270..<330: self = .purple
            default: self = .red
            }
        }

        public init(color: Color) {
            self.init(uiColor: UIColor(color))
        }

        public var title: String {
            switch self {
            case .red: L10n.red
            case .orange: L10n.orange
            case .yellow: L10n.yellow
            case .green: L10n.green
            case .blue: L10n.blue
//            case .cyan: L10n.cyan
            case .purple: L10n.purple
            }
        }
    }

    internal func getRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        return (red, green, blue)
    }

    internal func rgbToHSB(red: CGFloat, green: CGFloat, blue: CGFloat) -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        let maxColor = max(red, green, blue)
        let minColor = min(red, green, blue)
        let delta = maxColor - minColor

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = maxColor

        if maxColor == minColor {
            hue = 0
        } else {
            if maxColor == red {
                hue = (60 * ((green - blue) / delta).truncatingRemainder(dividingBy: 360)) / 360
            } else if maxColor == green {
                hue = (60 * (blue - red) / delta) / 360 + 2
            } else {
                hue = (60 * (red - green) / delta) / 360 + 4
            }

            if hue < 0 {
                hue += 1
            }
        }

        if maxColor == 0 {
            saturation = 0
        } else {
            saturation = delta / maxColor
        }

        return (hue, saturation, brightness)
    }

    var hue: CGFloat {
        let value = getRGB()
        return rgbToHSB(red: value.red, green: value.green, blue: value.blue).hue
    }

    var hueCategory: HueCategory? {
        let normalizedHue = Int(hue.truncatingRemainder(dividingBy: 1) * 360)
        for category in HueCategory.allCases where category.hueRange.contains(normalizedHue) {
            return category
        }
        return nil
    }
}

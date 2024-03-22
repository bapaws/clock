//
//  DBManager.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/6.
//

import Foundation
import HoursShare
import RealmSwift
import SwiftUI
import UIKit

public extension DBManager {
    func setup() {
        do {
//            let decoder = JSONDecoder()
//            let jsonData = nipponColors.data(using: .utf8)
//            let colors = try decoder.decode([OneColor].self, from: jsonData!)
//            let hexs = colors.map { HexObject(hex: $0.hex) }
//
//            let events = realm.objects(EventObject.self)
//
//            try? realm.write {
//                for index in 0 ..< events.count {
//                    events[index].hex = hexs[index]
//                }
//            }

            let objects = realm.objects(CategoryObject.self)
            if objects.isEmpty {
                let json = getCategoryData()
                let data = json.data(using: .utf8)!
                let categorys = try JSONDecoder().decode([CategoryObject].self, from: data)
                try realm.write {
                    realm.add(categorys)
                }

                #if DEBUG
                    let events = realm.objects(EventObject.self)
                    try realm.write {
                        let now = Date.now
                        var startAt = AppManager.shared.initialDate
                        while startAt < now {
                            let milliseconds = Int.random(in: 60000...7200000)
                            let mode = RecordCreationMode(rawValue: Int.random(in: 0...2))!
                            let record = RecordObject(creationMode: mode, startAt: startAt, milliseconds: milliseconds)
                            realm.add(record)

                            let index = Int.random(in: 0 ..< events.count)
                            events[index].items.append(record)

                            startAt = startAt.addingTimeInterval(TimeInterval(milliseconds) / 1000)
                        }
                    }
                #endif
            } else {
                #if DEBUG
                    let jsonData = try JSONEncoder().encode(objects)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(jsonString)
                    }
                #endif
            }
        } catch {
            print(error)
        }

        if schemaVersion == 0 {
            guard self.categorys.isEmpty, self.hexs.isEmpty else { return }

            try? realm.write {
                let categorys = [
                    CategoryObject(hex: HexObject(hex: "#E3BEF2"), emoji: "🍲", name: R.string.localizable.life()),
                    CategoryObject(hex: HexObject(hex: "#DBEAB3"), emoji: "🧑🏻‍💻", name: R.string.localizable.work()),
                    CategoryObject(hex: HexObject(hex: "#FDDFDF"), emoji: "🎒", name: R.string.localizable.study()),
                    CategoryObject(hex: HexObject(hex: "#EDDD9E"), emoji: "🏃", name: R.string.localizable.sports()),
                    CategoryObject(hex: HexObject(hex: "#78C2C4"), emoji: "🎤", name: R.string.localizable.entertainment()),
                    CategoryObject(hex: HexObject(hex: "#777BCE"), emoji: "🎮", name: R.string.localizable.game()),
                ]
                self.realm.add(categorys)
            }

            if let jsonData = nipponColors.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let colors = try decoder.decode([OneColor].self, from: jsonData)
                    let hexs = colors.map { HexObject(hex: $0.hex) }
                    try realm.write {
                        self.realm.add(hexs)
                    }
                } catch {
                    print("\(error)")
                }
            }

            self.hexs = realm.objects(HexObject.self)
            self.categorys = realm.objects(CategoryObject.self)
        }
    }

    private func generateSimilarColors(baseColor: Color, numberOfColors: Int) -> [Color] {
        var similarColors: [Color] = []

        // 获取基准颜色的 HSB（色相、饱和度、亮度）值
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        baseColor.toUIColor()!.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        // 计算相近颜色的色相间隔
        let hueInterval: CGFloat = 1.0 / CGFloat(numberOfColors)

        // 计算色相的起始值
        var startHue = hue - hueInterval / 2

        // 循环生成相近颜色
        for _ in 0 ..< numberOfColors {
            // 处理色相值小于0或大于1的情况
            if startHue < 0 {
                startHue += 1
            } else if startHue > 1 {
                startHue -= 1
            }

            let similarColor = UIColor(hue: startHue, saturation: saturation, brightness: brightness, alpha: alpha)
            similarColors.append(Color(similarColor))

            startHue += hueInterval
        }

        return similarColors
    }
}

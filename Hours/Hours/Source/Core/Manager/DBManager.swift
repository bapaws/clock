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
    var json: String { """
    [{"emoji":"👨🏻‍💻","category":{"hex":{"dark":"#FDDFDF","light":"#FDDFDF"},"emoji":null,"icon":"graduationcap","name":"学习"},"createdAt":731686877.738567,"name":"英语","_id":"65ec705daddba53b60aca1be","hex":{"light":"#E3BEF2","dark":"#E3BEF2"},"items":[{"creationMode":1,"startAt":731686877.848944,"milliseconds":1002}]},{"emoji":"😆","category":{"emoji":null,"hex":{"light":"#FDDFDF","dark":"#FDDFDF"},"name":"学习","icon":"graduationcap"},"createdAt":731686893.805073,"_id":"65ec706daddba53b60aca1c1","name":"数学","hex":{"dark":"#DBEAB3","light":"#DBEAB3"},"items":[{"creationMode":1,"milliseconds":1501,"startAt":731686893.866343}]},{"items":[{"creationMode":1,"startAt":731686913.883149,"milliseconds":1001}],"_id":"65ec7081addba53b60aca1c4","emoji":"🛈","category":{"emoji":null,"icon":"figure.run","hex":{"dark":"#EDDD9E","light":"#EDDD9E"},"name":"运动"},"createdAt":731686913.809013,"hex":{"dark":"#FDDFDF","light":"#FDDFDF"},"name":"跑步"},{"items":[{"milliseconds":1001,"startAt":731686929.036935,"creationMode":1}],"hex":{"light":"#EDDD9E","dark":"#EDDD9E"},"emoji":"🚣","createdAt":731686928.966461,"category":{"emoji":null,"icon":"figure.run","name":"运动","hex":{"dark":"#EDDD9E","light":"#EDDD9E"}},"_id":"65ec7090addba53b60aca1c7","name":"游泳"},{"name":"语文","emoji":"🚴","category":{"icon":"graduationcap","hex":{"light":"#FDDFDF","dark":"#FDDFDF"},"name":"学习","emoji":null},"_id":"65ec70b0addba53b60aca1ca","items":[{"milliseconds":1001,"startAt":731686960.750193,"creationMode":1}],"hex":{"light":"#78C2C4","dark":"#78C2C4"},"createdAt":731686960.640491},{"name":"洗衣服","category":{"emoji":null,"hex":{"light":"#E3BEF2","dark":"#E3BEF2"},"icon":"balloon.2","name":"生活"},"createdAt":731686977.080843,"hex":{"light":"#777BCE","dark":"#777BCE"},"_id":"65ec70c1addba53b60aca1cd","items":[{"milliseconds":1001,"creationMode":1,"startAt":731686977.156195}],"emoji":"🛿"},{"name":"听音乐","emoji":"🛉","_id":"65ec70e9addba53b60aca1d0","createdAt":731687017.619374,"hex":{"light":"#DC9FB4","dark":"#DC9FB4"},"category":{"name":"娱乐","emoji":null,"hex":{"dark":"#78C2C4","light":"#78C2C4"},"icon":"music.note"},"items":[{"milliseconds":1001,"startAt":731687017.727147,"creationMode":1}]}]
    """
    }

    func setup() {
        do {
            let objects = realm.objects(EventObject.self)
            if objects.isEmpty, let data = json.data(using: .utf8)  {
                let events = try JSONDecoder().decode([EventObject].self, from: data)
                try realm.write {
                    realm.add(events)
                }
            } else {
                let jsonData = try JSONEncoder().encode(objects)
                if  let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            }
        } catch {
            print(error)
        }


        if schemaVersion == 0 {
            guard self.categorys.isEmpty, self.hexs.isEmpty else { return }

            let categorys = [
                CategoryObject(hex: HexObject(hex: "#E3BEF2"), icon: "balloon.2", name: R.string.localizable.life()),
                CategoryObject(hex: HexObject(hex: "#DBEAB3"), icon: "magicmouse", name: R.string.localizable.work()),
                CategoryObject(hex: HexObject(hex: "#FDDFDF"), icon: "graduationcap", name: R.string.localizable.study()),
                CategoryObject(hex: HexObject(hex: "#EDDD9E"), icon: "figure.run", name: R.string.localizable.sports()),
                CategoryObject(hex: HexObject(hex: "#78C2C4"), icon: "music.note", name: R.string.localizable.entertainment()),
                CategoryObject(hex: HexObject(hex: "#777BCE"), icon: "gamecontroller", name: R.string.localizable.game()),
            ]
            try? realm.write {
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

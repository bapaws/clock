//
//  File.swift
//
//
//  Created by 张敏超 on 2024/6/15.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        let colors: [UIColor] = [
            .systemRed,
            .systemGreen,
            .systemBlue,
            .systemOrange,
            .systemYellow,
            .systemPink,
            .systemPurple,
            .systemTeal,
            .systemIndigo,
            .systemBrown,
            .systemMint,
            .systemCyan
        ]
        let index = Int.random(in: colors.indices)
        let style = UIUserInterfaceStyle(rawValue: Int.random(in: 1 ... 2)) ?? .light
        let trait = UITraitCollection(userInterfaceStyle: style)
        return colors[index].resolvedColor(with: trait)
    }
}

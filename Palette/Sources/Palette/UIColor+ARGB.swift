//
//  UIColor+ARGB.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/26.
//

import UIKit

public extension UIColor {
    var argb: Int {
        var (r, g, b, a) = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
        getRed(&r, green: &g, blue: &b, alpha: &a)

        return ColorUtils.argb(
            red: Int(round(r * 255.0)),
            green: Int(round(g * 255.0)),
            blue: Int(round(b * 255.0))
        )
    }
}

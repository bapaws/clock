//
//  NeumorphicPortraitColon.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/24.
//

import Neumorphic
import SwiftUI

struct NeumorphicPortraitColon: View {
    let outer: Bool
    let color: Colors

    var body: some View {
        HStack(spacing: 24) {
            if outer {
                Circle()
                    .fill(color.background)
                    .softOuterShadow(darkShadow: color.darkShadow, lightShadow: color.lightShadow)
                Circle()
                    .fill(color.background)
                    .softOuterShadow(darkShadow: color.darkShadow, lightShadow: color.lightShadow)
            } else {
                Circle()
                    .fill(color.background)
                    .softInnerShadow(Circle(), darkShadow: color.darkShadow, lightShadow: color.lightShadow)
                Circle()
                    .fill(color.background)
                    .softInnerShadow(Circle(), darkShadow: color.darkShadow, lightShadow: color.lightShadow)
            }
        }
    }
}

#Preview {
    NeumorphicPortraitColon(outer: true, color: ColorType.classic.colors)
        .environmentObject(UIManager.shared)
}

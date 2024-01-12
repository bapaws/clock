//
//  NeumorphicLandspaceColon.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import Neumorphic
import SwiftUI

struct NeumorphicLandspaceColon: View {
    let outer: Bool
    let color: Colors

    var body: some View {
        VStack(spacing: 24) {
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
    HStack {
        NeumorphicLandspaceColon(outer: true, color: ColorType.classic.colors)
        NeumorphicLandspaceColon(outer: false, color: ColorType.classic.colors)
    }
}

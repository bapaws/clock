//
//  NeumorphicLandspaceColon.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/24.
//

import Neumorphic
import SwiftUI

struct NeumorphicLandspaceColon: View {
    let outer: Bool

    @EnvironmentObject var ui: UIManager

    var body: some View {
        VStack(spacing: 24) {
            if outer {
                Circle()
                    .fill(ui.color.background)
                    .softOuterShadow(darkShadow: ui.color.darkShadow, lightShadow: ui.color.lightShadow)
                Circle()
                    .fill(ui.color.background)
                    .softOuterShadow(darkShadow: ui.color.darkShadow, lightShadow: ui.color.lightShadow)
            } else {
                Circle()
                    .fill(ui.color.background)
                    .softInnerShadow(Circle(), darkShadow: ui.color.darkShadow, lightShadow: ui.color.lightShadow)
                Circle()
                    .fill(ui.color.background)
                    .softInnerShadow(Circle(), darkShadow: ui.color.darkShadow, lightShadow: ui.color.lightShadow)
            }
        }
    }
}

#Preview {
    HStack {
        NeumorphicLandspaceColon(outer: true)
        NeumorphicLandspaceColon(outer: false)
    }
    .environmentObject(UIManager.shared)
}

//
//  NeumorphicButton.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DeskClockShare
import SwiftUI
import SwiftUIX
import Neumorphic

let neumorphicButtonSize = CGSize(width: 56, height: 56)

struct NeumorphicButton<Content: View>: View {
    let action: () -> Void
    let label: () -> Content

    var minimumDuration: Double = 3.0

    @EnvironmentObject var ui: UIManager

    init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: action, label: {
            label().frame(width: 24, height: 24)
        })
        .softButtonStyle(Circle(), mainColor: ui.colors.background, textColor: ui.colors.primary, darkShadowColor: ui.colors.darkShadow, lightShadowColor: ui.colors.lightShadow)
        .frame(neumorphicButtonSize)
    }
}

#Preview {
    NeumorphicButton {
        print("NeumorphicButton")
    } label: {
        Image(systemName: "play")
    }
    .environmentObject(UIManager.shared)
}

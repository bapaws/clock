//
//  HoldOnNeumorphicButton.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/29.
//

import Neumorphic
import SwiftUI
import SwiftUIX

struct HoldOnNeumorphicButton<Label: View>: View {
    var color: Colors
    var action: () -> Void
    var label: () -> Label

    var minimumDuration: Double = 3.0
    @State private var isPressed = false

    var body: some View {
        label()
            .frame(width: 24, height: 24)
            .foregroundColor(color.primary)
            .padding(16)
            .scaleEffect(isPressed ? 0.97 : 1)
            .background(
                ZStack {
                    let shape = Circle()
                    shape.fill(color.background)
                        .softInnerShadow(shape, darkShadow: color.darkShadow, lightShadow: color.lightShadow, spread: 0.15, radius: 3)
                        .opacity(isPressed ? 1 : 0)
                    shape.fill(color.background)
                        .softOuterShadow(darkShadow: color.darkShadow, lightShadow: color.lightShadow, offset: 6, radius: 3)
                        .opacity(isPressed ? 0 : 1)
                }
            )
            .overlay {
                Circle()
                    .trim(from: 0, to: isPressed ? 1 : .leastNonzeroMagnitude)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .foregroundStyle(color.primary)
                    .rotationEffect(.degrees(-90))
            }
            .onLongPressGesture(minimumDuration: minimumDuration, perform: action) { isPressed in
                let duration = isPressed ? minimumDuration : 0.25
                withAnimation(Animation.linear(duration: duration)) {
                    self.isPressed = isPressed
                }
            }
    }
}

#Preview {
    HoldOnNeumorphicButton(color: ColorType.classic.colors, action: {}) {
        Image(systemName: "stop")
    }
}

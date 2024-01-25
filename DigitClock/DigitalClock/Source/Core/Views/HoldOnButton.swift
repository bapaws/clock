//
//  HoldOnButton.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/29.
//

import ClockShare
import DigitalClockShare
import SwiftUI
import SwiftUIX

struct HoldOnButton<Label: View>: View {
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
    HoldOnButton(color: ColorType.classic.colors, action: {}) {
        Image(systemName: "stop")
    }
}

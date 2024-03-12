//
//  HoldOnButton.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/29.
//

import ClockShare
import SwiftUI
import SwiftUIX

public struct HoldOnButton<Label: View>: View {
    var strokeColor: Color = .red
    var action: () -> Void
    var label: Label

    var minimumDuration: Double = 3.0
    @State private var isPressed = false

    public init(strokeColor: Color, action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.strokeColor = strokeColor
        self.action = action
        self.label = label()
    }

    public var body: some View {
        label
            .scaleEffect(isPressed ? 0.97 : 1)
            .padding()
            .overlay {
                Circle()
                    .trim(from: 0, to: isPressed ? 1 : .leastNonzeroMagnitude)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .foregroundStyle(strokeColor)
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

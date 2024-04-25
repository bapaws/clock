//
//  TimeRecordClock.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/4/2.
//

import ClockShare
import SwiftUI

public struct TimeRecordClock: View {
    let time: Time
    let secondStyle: DigitStyle

    @EnvironmentObject var ui: UIManager
    @Environment(\.colorScheme) var colorScheme

    let lineWidth: CGFloat = 1

    var labelColor: Color {
        switch ui.darkMode {
        case .dark: Color.white
        case .light: Color.black
        case .system: Color(uiColor: .init { $0.userInterfaceStyle == .dark ? UIColor.white : UIColor.black })
        }
    }

    public init(time: Time, secondStyle: DigitStyle = .none) {
        self.time = time
        self.secondStyle = secondStyle
    }

    public var body: some View {
        GeometryReader { proxy in
            let length = proxy.size.minimumDimensionLength
            let radius = length / 10 * 4
            let offset = floor(radius / 12)
            ZStack {
                Circle()
                    .fill(Color.systemMint)
                    .frame(width: radius * 2, height: radius * 2, alignment: .center)
                    .offset(x: offset, y: offset)

                Circle()
                    .stroke(labelColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .frame(width: radius * 2, height: radius * 2, alignment: .center)

                let center = CGPoint(x: length / 2, y: length / 2)

                Path { path in
                    path.move(to: center)
                    let hourX = center.x + sin(degrees(for: time.hour, totalValue: 12)) * radius / 5 * 2
                    let hourY = center.y - cos(degrees(for: time.hour, totalValue: 12)) * radius / 5 * 2
                    path.addLine(to: CGPoint(x: hourX, y: hourY))

                    path.move(to: center)
                    let minuteX = center.x + sin(degrees(for: time.minute)) * radius / 10 * 7
                    let minuteY = center.y - cos(degrees(for: time.minute)) * radius / 10 * 7
                    path.addLine(to: CGPoint(x: minuteX, y: minuteY))
                }
                .stroke(labelColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))

                if secondStyle != .none {
                    Path { path in
                        path.move(to: center)
                        let secondX = center.x + sin(degrees(for: time.second)) * radius / 10 * 9
                        let secondY = center.y - cos(degrees(for: time.second)) * radius / 10 * 9
                        path.addLine(to: CGPoint(x: secondX, y: secondY))
                    }
                    .stroke(Color.systemRed, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                }
            }
            .frame(width: length, height: length)
        }
    }

    func degrees(for value: Int, totalValue: Int = 60) -> Double {
        return Double(value) / Double(totalValue) * 2 * Double.pi
    }
}

#Preview {
    TimeRecordClock(time: Time())
}

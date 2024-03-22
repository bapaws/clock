//
//  LogoView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/20.
//

import HoursShare
import Palette
import SwiftUI
import SwiftUIX

#if DEBUG
struct GradientLine: Shape {
    let lineWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width / 3, y: rect.height / 3 + lineWidth))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height / 2 + lineWidth))
        path.addArc(center: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: rect.width / 2 - lineWidth, startAngle: .degrees(-40), endAngle: .degrees(90), clockwise: true)
        return path
    }
}

struct LogoView: View {
    @Environment(\.colorScheme) var colorScheme

    let length: CGFloat = 1024
    let radius: CGFloat = 360
    let lineWidth: CGFloat = 10

    var body: some View {
        ZStack {
            Color.systemBackground
//            Text("\(Color.systemMint.toUIColor()?.argb)")

            Circle()
                .fill(Color(argb: 0xFF00C7BE))
                .frame(width: radius * 2 - 10, height: radius * 2 - 10, alignment: .center)
                .offset(x: radius / 8, y: radius / 8)

            Circle()
                .stroke(Color.label, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .frame(width: radius * 2, height: radius * 2, alignment: .center)

            Path { path in
                path.move(to: CGPoint(x: length / 2, y: length / 2))
                path.addLine(to: CGPoint(x: length / 2, y: length / 2 - radius / 5 * 4))
                path.move(to: CGPoint(x: length / 2, y: length / 2))
                path.addLine(to: CGPoint(x: length / 2 - radius / 5 * 2, y: length / 2))
            }
            .rotation(.degrees(45))
            .stroke(Color.label, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
        }
        .frame(width: length, height: length)
        .capture(size: CGSize(width: length, height: length), scale: 1, ignoreSafeArea: true) { image in
            print(image!)
        }
    }
}

#Preview {
    LogoView()
}
#endif

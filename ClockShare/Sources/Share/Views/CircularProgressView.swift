//
//  CircularProgressView.swift
//
//
//  Created by 张敏超 on 2024/1/11.
//

import SwiftUI
import SwiftUIX

public struct CircularProgressView: View {
    public var progress: Double
    public var lineWidth: CGFloat = 2
    public var lineColor: Color = .systemBackground

    public init(progress: Double, lineWidth: CGFloat = 2, lineColor: Color = .systemBackground) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(
                    lineColor.opacity(0.5),
                    lineWidth: 30
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    lineColor,
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
        }
    }
}

#Preview {
    CircularProgressView(progress: 0.25)
}

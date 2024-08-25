//
//  TimeRangeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/25.
//

import SwiftUI

public struct TimeRangeView: View {
    var startAt: Date
    var endAt: Date

    var spacing: CGFloat = 8

    init(startAt: Date, endAt: Date, spacing: CGFloat = 8) {
        self.startAt = startAt
        self.endAt = endAt
        self.spacing = spacing
    }

    init(range: Range<Date>, spacing: CGFloat = 8) {
        self.startAt = range.lowerBound
        self.endAt = range.upperBound
        self.spacing = spacing
    }

    public var body: some View {
        HStack(spacing: spacing) {
            Text(startAt.toString(.time(.short)))
            Text("~")
            Text(endAt.toString(.time(.short)))
        }
        .font(.body)
    }
}

#Preview {
    VStack {
        TimeRangeView(startAt: Date.now, endAt: Date(timeIntervalSinceNow: 1000))
        TimeRangeView(range: Date.now ..< Date(timeIntervalSinceNow: 2000))
    }
}

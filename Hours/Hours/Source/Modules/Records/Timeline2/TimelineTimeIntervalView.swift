//
//  TimelineTimeIntervalView.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/24.
//

import SwiftUI
import SwiftUIX

struct TimelineTimeIntervalView: View {
    let range: Range<Date>
    var body: some View {
        HStack {
            HStack {
                Rectangle()
                    .fill(ui.primary)
                    .frame(width: 1)
            }
            .frame(width: 18)

            Rectangle()
                .fill(Color.secondaryLabel)
                .frame(width: 16, height: 1)

            Text(duartion.shortTimeLengthText)
                .font(.callout)
                .padding(.vertical, 24)

            Spacer()
        }
        .foregroundStyle(ui.label)
    }

    var duartion: Int {
        Int((range.upperBound.timeIntervalSince1970 - range.lowerBound.timeIntervalSince1970) * 1000)
    }
}

#Preview {
    TimelineTimeIntervalView(range: Date(timeIntervalSinceNow: -100) ..< Date.now)
}

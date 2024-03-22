//
//  StatisticsTimeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/7.
//

import HoursShare
import SwiftUI

struct StatisticsTimeView: View {
    let time: TimeLength
    var numberFont: Font = .title2
    var numberWeight: Font.Weight = .bold
    var unitFont: Font = .body

    var body: some View {
        HStack {
            if time.day > 0 {
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(time.day)")
                        .font(numberFont, weight: numberWeight)
                        .foregroundStyle(Color.label)
                    Text(R.string.localizable.days())
                        .font(unitFont)
                        .foregroundStyle(Color.tertiaryLabel)
                }
            }

            if time.hour > 0 {
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(time.hour)")
                        .font(numberFont, weight: numberWeight)
                        .foregroundStyle(Color.label)
                    Text(R.string.localizable.hours())
                        .font(unitFont)
                        .foregroundStyle(Color.tertiaryLabel)
                }
            }

            if time.day == 0, time.minute > 0 {
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(time.minute)")
                        .font(numberFont, weight: numberWeight)
                        .foregroundStyle(Color.label)
                    Text(R.string.localizable.minutes())
                        .font(unitFont)
                        .foregroundStyle(Color.tertiaryLabel)
                }
            }

            if time.day == 0, time.hour == 0 {
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(time.second)")
                        .font(numberFont, weight: numberWeight)
                        .foregroundStyle(Color.label)
                    Text(R.string.localizable.seconds())
                        .font(unitFont)
                        .foregroundStyle(Color.tertiaryLabel)
                }
            }
        }
    }
}

#Preview {
    StatisticsTimeView(time: (2, 11, 20, 25))
}

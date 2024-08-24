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
    var numberColor: Color = .label
    var unitFont: Font = .body
    var spacing: CGFloat = 8

    var body: some View {
        HStack(spacing: spacing) {
            if time.day > 0 {
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(time.day)")
                        .font(numberFont, weight: numberWeight)
                        .foregroundStyle(numberColor)
                    Text(L10n.days)
                        .font(unitFont)
                        .foregroundStyle(Color.tertiaryLabel)
                }
            }

            if time.hour > 0 {
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(time.hour)")
                        .font(numberFont, weight: numberWeight)
                        .foregroundStyle(numberColor)
                    Text(L10n.hours)
                        .font(unitFont)
                        .foregroundStyle(Color.tertiaryLabel)
                }
            }

            if time.day == 0, time.minute > 0 {
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(time.minute)")
                        .font(numberFont, weight: numberWeight)
                        .foregroundStyle(numberColor)
                    Text(L10n.minutes)
                        .font(unitFont)
                        .foregroundStyle(Color.tertiaryLabel)
                }
            }

            if time.day == 0, time.hour == 0, time.second > 0 {
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(time.second)")
                        .font(numberFont, weight: numberWeight)
                        .foregroundStyle(numberColor)
                    Text(L10n.seconds)
                        .font(unitFont)
                        .foregroundStyle(Color.tertiaryLabel)
                }
            }
        }
    }
}

#Preview {
    VStack {
        StatisticsTimeView(time: TimeLength(integer: 1231231231))
        StatisticsTimeView(time: TimeLength(integer: 1200000))
    }
}

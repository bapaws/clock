//
//  StatisticsDayTimeDistributionView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import Charts
import IdentifiedCollections
import SwiftDate
import SwiftUI

struct StatisticsDayTimeDistributionView: View {
    let timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>

    var body: some View {
        StatisticsTimeDistributionView(
            timeDistributions: timeDistributions,
            y: \.totalMinutes
        ) {
            AxisMarks(values: .automatic()) { value in
                if let date = value.as(Date.self) {
                    switch date.hour {
                    case 0, 12:
                        AxisValueLabel(format: .dateTime.hour())
                    default:
                        AxisValueLabel(format: .dateTime.hour(.defaultDigits(amPM: .omitted)))
                    }
                }
            }
        }
    }
}

#Preview {
    StatisticsDayTimeDistributionView(
        timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>()
    )
}

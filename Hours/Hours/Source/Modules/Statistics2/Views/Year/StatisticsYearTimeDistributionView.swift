//
//  StatisticsMonthTimeDistributionView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import Charts
import IdentifiedCollections
import SwiftDate
import SwiftUI

struct StatisticsYearTimeDistributionView: View {
    let timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>

    var body: some View {
        Chart(timeDistributions) { item in
            AreaMark(
                x: .value("Time", item.range.lowerBound),
                y: .value("Minutes", item.totalHours)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(LinearGradient(colors: [ui.primary, .clear], startPoint: .top, endPoint: .bottom))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .month, count: 2)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel(SwiftDate.defaultRegion.calendar.shortMonthSymbols[date.month - 1])
                }
            }
        }
        .height(250)
        .padding()
        .padding(.vertical)
    }
}

#Preview {
    StatisticsMonthTimeDistributionView(
        timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>()
    )
}

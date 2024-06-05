//
//  StatisticsWeekTimeDistributionView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import Charts
import IdentifiedCollections
import SwiftDate
import SwiftUI

struct StatisticsWeekTimeDistributionView: View {
    let timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>

    var body: some View {
        StatisticsTimeDistributionLineView(timeDistributions: timeDistributions, y: \.totalHours) {
            AxisMarks(values: .stride(by: .day, count: 1)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel(date.toString(.custom("EE")))
                }
            }
        } yAxis: {
            AxisMarks(values: .stride(by: Double(6)))
        }
    }
}

#Preview {
    StatisticsWeekTimeDistributionView(
        timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>()
    )
}

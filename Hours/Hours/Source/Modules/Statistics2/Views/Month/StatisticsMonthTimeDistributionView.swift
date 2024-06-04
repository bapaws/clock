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

struct StatisticsMonthTimeDistributionView: View {
    let timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>

    var body: some View {
        StatisticsTimeDistributionView(timeDistributions: timeDistributions, y: \.totalHours) {
            AxisMarks(values: .stride(by: .day, count: 5)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel("\(date.day)")
                }
            }
        }
    }
}

#Preview {
    StatisticsMonthTimeDistributionView(
        timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>()
    )
}

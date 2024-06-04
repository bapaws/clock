//
//  StatisticsTimeDistributionView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/2.
//

import Charts
import ComposableArchitecture
import SwiftUI

struct StatisticsTimeDistributionView<XAxis: AxisContent, YAxis: AxisContent>: View {
    let timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>
    let y: (StatisticsTimeDistribution) -> Double
    let xAxis: () -> XAxis
    let yAxis: () -> YAxis

    init(
        timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>,
        y: @escaping (StatisticsTimeDistribution) -> Double,
        xAxis: @escaping () -> XAxis,
        yAxis: @escaping () -> YAxis
    ) {
        self.timeDistributions = timeDistributions
        self.y = y
        self.xAxis = xAxis
        self.yAxis = yAxis
    }

    var body: some View {
        Chart(timeDistributions) { item in
            AreaMark(
                x: .value("Time", item.range.lowerBound),
                y: .value("Minutes", y(item))
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(LinearGradient(colors: [ui.primary, .clear], startPoint: .top, endPoint: .bottom))
        }
        .chartYAxis {
            yAxis()
        }
        .chartXAxis {
            xAxis()
        }
        .height(250)
        .padding()
        .padding(.vertical)
    }
}

extension StatisticsTimeDistributionView where YAxis == AxisMarks<Never> {
    init(
        timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>,
        y: @escaping (StatisticsTimeDistribution) -> Double,
        xAxis: @escaping () -> XAxis
    ) {
        self.init(timeDistributions: timeDistributions, y: y, xAxis: xAxis) {
            AxisMarks(values: .automatic)
        }
    }
}

#Preview {
    StatisticsTimeDistributionView(
        timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution>(),
        y: \.totalMinutes
    ) {
        AxisMarks(values: .stride(by: .hour, count: 6)) { value in
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

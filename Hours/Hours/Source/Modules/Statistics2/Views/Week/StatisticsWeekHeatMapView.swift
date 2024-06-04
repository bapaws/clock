//
//  StatisticsWeekHeatMapView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import SwiftDate
import SwiftUI

struct StatisticsWeekHeatMapView: View {
    let heatMapTimeInterval: TimeInterval
    let heatMaps: [StatisticsHeatMap]

    let rowHeight: CGFloat = 24
    let hourWidth: CGFloat = 48
    let weekWidth: CGFloat = 18

    var body: some View {
        VStack {
            let spacing: CGFloat = 6

            let hourCount = Int(24 * 3600 / heatMapTimeInterval)
            GeometryReader { proxy in
                HStack(spacing: spacing) {
                    Color.clear.frame(width: weekWidth)

                    let dimension = (proxy.size.width - weekWidth - CGFloat(hourCount) * spacing) / CGFloat(hourCount)
                    ForEach(0 ..< hourCount, id: \.self) { index in
                        Text("\(Int(heatMapTimeInterval * TimeInterval(index) / 3600))")
                            .minimumScaleFactor(0.5)
                    }
                    .frame(width: dimension, height: rowHeight)
                }
            }
            .frame(height: rowHeight)

            HStack {
                LazyVStack(spacing: spacing) {
                    let calendar = SwiftDate.defaultRegion.calendar
                    let symbols = calendar.veryShortWeekdaySymbols
                    ForEach(0..<symbols.count, id: \.self) {
                        Text(symbols[$0])
                            .minimumScaleFactor(0.5)
                            .frame(width: weekWidth, height: rowHeight, alignment: .trailing)
                    }
                }
                .frame(width: weekWidth, height: rowHeight * 7 + spacing * 6)

                GeometryReader { proxy in
                    let dimension = (proxy.size.width - CGFloat(hourCount - 1) * spacing) / CGFloat(hourCount)
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(dimension), spacing: spacing), count: hourCount), spacing: spacing) {
                        ForEach(heatMaps) { heatMap in
                            Group {
                                if let event = heatMap.record?.event, let hex = event.hex {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(hex.primaryContainer)

                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(ui.background)
                                }
                            }
                        }
                        .frame(height: rowHeight)
                    }
                }
            }
        }
        .font(.footnote)
        .foregroundStyle(ui.secondaryLabel)
        .padding()
    }
}

#Preview {
    StatisticsWeekHeatMapView(
        heatMapTimeInterval: 2 * 3600,
        heatMaps: StatisticsHeatMap.random()
    )
}

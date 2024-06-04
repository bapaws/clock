//
//  StatisticsMonthHeatMapView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/4.
//

import SwiftDate
import SwiftUI
import SwiftUIX

struct StatisticsMonthHeatMapView: View {
    let contributions: [StatisticsContribution]
    let maxMilliseconds: Int

    let rowHeight: CGFloat = 36
    let headerHeight: CGFloat = 24

    var body: some View {
        VStack {
            let symbols = SwiftDate.defaultRegion.calendar.shortWeekdaySymbols
            HStack {
                ForEach(symbols, id: \.self) { symbol in
                    Text(symbol)
                }
                .frame(width: rowHeight, height: headerHeight)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.fixed(rowHeight)), count: symbols.count)) {
                ForEach(contributions) { contribution in
                    Text("\(contribution.range.lowerBound.day)")
                        .foregroundStyle(textForegroundColor(for: contribution))
                        .frame(width: rowHeight, height: rowHeight, alignment: .center)
                        .background {
                            if let milliseconds = contribution.totalMilliseconds {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(milliseconds == 0 ? ui.background : ui.primary.opacity(Double(milliseconds) / Double(maxMilliseconds) * 0.8 + 0.2))
                            } else {
                                Color.clear
                            }
                        }
                }
                .frame(width: rowHeight, height: rowHeight)
            }
        }
        .font(.footnote)
        .foregroundStyle(ui.secondaryLabel)
        .padding(.vertical, .large)
    }

    func textForegroundColor(for contribution: StatisticsContribution) -> Color {
        if let totalMilliseconds = contribution.totalMilliseconds {
            if totalMilliseconds > maxMilliseconds / 3 {
                return .white
            } else {
                return ui.secondaryLabel
            }
        } else {
            return Color.quaternaryLabel
        }
    }
}

#Preview {
    StatisticsMonthHeatMapView(contributions: [], maxMilliseconds: 100)
}

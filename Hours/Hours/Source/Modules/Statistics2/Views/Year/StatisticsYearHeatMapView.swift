//
//  StatisticsYearHeatMapView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import SwiftDate
import SwiftUI
import SwiftUIX

struct StatisticsYearHeatMapView: View {
    let contributions: [StatisticsContribution]
    let months: [StatisticsContributionMonth]
    let maxMilliseconds: Int

    let rowHeight: CGFloat = 28
    let headerHeight: CGFloat = 15
    let weekWidth: CGFloat = 36

    var body: some View {
        HStack {
            VStack {
                Color.clear
                    .frame(width: rowHeight, height: headerHeight)

                let calendar = SwiftDate.defaultRegion.calendar
                let symbols = calendar.shortWeekdaySymbols
                ForEach(symbols, id: \.self) {
                    Text($0)
                        .minimumScaleFactor(0.5)
                }
                .frame(width: weekWidth, height: rowHeight, alignment: .trailing)
            }
            .frame(width: weekWidth, height: rowHeight * 7 + 48)

            ScrollView(.horizontal) {
                VStack {
                    header
                    LazyHGrid(rows: Array(repeating: GridItem(.fixed(rowHeight)), count: 7)) {
                        ForEach(contributions) { contribution in
                            Group {
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
            }
            .scrollIndicators(.never)
        }
        .font(.footnote)
        .foregroundStyle(ui.secondaryLabel)
        .padding()
    }

    private var header: some View {
        LazyHStack(pinnedViews: .sectionHeaders) {
            ForEach(months) {
                if let symbol = $0.symbol {
                    Text(symbol)
                } else {
                    Color.clear
                }
            }
            .frame(width: rowHeight, height: headerHeight)
        }
        .foregroundStyle(ui.secondaryLabel)
    }
}

#Preview {
    StatisticsYearHeatMapView(contributions: [], months: [], maxMilliseconds: 100)
}

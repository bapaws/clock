//
//  StatisticsDailyEventView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/13.
//

import Charts
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI
import SwiftUIX

struct StatisticsDailyEventView: View {
    @EnvironmentObject var viewModel: StatisticsViewModel

    @Environment(\.colorScheme) var colorScheme

    var totalMilliseconds: Int { viewModel.dailyTotalMilliseconds }

    var body: some View {
        Group {
            if #available(iOS 17.0, *) {
                ZStack {
                    if totalMilliseconds > 0 {
                        Chart(0 ..< viewModel.dailyEvents.count, id: \.self) { index in
                            let event = viewModel.dailyEvents[index]
                            let milliseconds = viewModel.dailyEventMilliseconds[index]
                            SectorMark(angle: .value(event.name, milliseconds), innerRadius: .ratio(0.618), angularInset: 1)
                                .cornerRadius(8)
                                .foregroundStyle(event.color)
                        }
                    }

                    VStack {
                        Text(R.string.localizable.totalInvest())
                            .font(.footnote)
                            .foregroundStyle(Color.secondaryLabel)
                        Text(totalMilliseconds.shortTimeLengthText)
                            .font(.title)
                    }
                }
                .height(250)
                .padding(.bottom)
            }

            if totalMilliseconds > 0 {
                getRatioView(totalMilliseconds: totalMilliseconds)
            }
        }
    }

    func getRatioView(totalMilliseconds: Int) -> some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 8) {
            let count = viewModel.dailyEvents.count
            ForEach(0 ..< (count / 2), id: \.self) { index in
                GridRow {
                    let leftEvent = viewModel.dailyEvents[index * 2]
                    let leftMilliseconds = viewModel.dailyEventMilliseconds[index * 2]
                    StatisticsDailyRatioView(title: leftEvent.name, milliseconds: leftMilliseconds, totalMilliseconds: totalMilliseconds, foregroundColor: leftEvent.color)


                        let rightEvent = viewModel.dailyEvents[index * 2 + 1]
                        let rightMilliseconds = viewModel.dailyEventMilliseconds[index * 2 + 1]
                        StatisticsDailyRatioView(title: rightEvent.name, milliseconds: rightMilliseconds, totalMilliseconds: totalMilliseconds, foregroundColor: rightEvent.color)
                    
                }
            }

            if count % 2 == 1 {
                GridRow {
                    let leftEvent = viewModel.dailyEvents[count - 1]
                    let leftMilliseconds = viewModel.dailyEventMilliseconds[count - 1]
                    StatisticsDailyRatioView(title: leftEvent.name, milliseconds: leftMilliseconds, totalMilliseconds: totalMilliseconds, foregroundColor: leftEvent.color)
                }
            }
        }
    }
}

#Preview {
    StatisticsDailyEventView()
        .environmentObject(StatisticsViewModel())
}

//
//  StatisticsTimeDistributionView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/14.
//

import Charts
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI
import SwiftUIX

struct StatisticsTimeDistributionView: View {
    @EnvironmentObject var viewModel: StatisticsViewModel

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                Text(R.string.localizable.timeDistribution())
                    .font(.title3)
                    .foregroundStyle(Color.secondaryLabel)

                Spacer()
            }

            Picker(selection: $viewModel.distributionType.animation()) {
                ForEach(StatisticsTimeDistributionType.allCases) {
                    Text($0.title)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)

            let totalMilliseconds = viewModel.distributionEventMilliseconds.reduce(0, +)

            if #available(iOS 17.0, *) {
                ZStack {
                    if totalMilliseconds > 0 {
                        Chart(0 ..< viewModel.distributionEvents.count, id: \.self) { index in
                            let event = viewModel.distributionEvents[index]
                            let milliseconds = viewModel.distributionEventMilliseconds[index]
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
            }

            if totalMilliseconds > 0 {
                getRatioView(totalMilliseconds: totalMilliseconds)
            }
        }
        .padding()
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }

    func getRatioView(totalMilliseconds: Int) -> some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 8) {
            let count = viewModel.distributionEvents.count
            ForEach(0 ..< (count / 2), id: \.self) { index in
                GridRow {
                    let leftEvent = viewModel.distributionEvents[index * 2]
                    let leftMilliseconds = viewModel.distributionEventMilliseconds[index * 2]
                    StatisticsDailyRatioView(title: leftEvent.name, milliseconds: leftMilliseconds, totalMilliseconds: totalMilliseconds, foregroundColor: leftEvent.color)

                    let rightEvent = viewModel.distributionEvents[index * 2 + 1]
                    let rightMilliseconds = viewModel.distributionEventMilliseconds[index * 2 + 1]
                    StatisticsDailyRatioView(title: rightEvent.name, milliseconds: rightMilliseconds, totalMilliseconds: totalMilliseconds, foregroundColor: rightEvent.color)
                }
            }

            if count % 2 == 1 {
                GridRow {
                    let leftEvent = viewModel.distributionEvents[count - 1]
                    let leftMilliseconds = viewModel.distributionEventMilliseconds[count - 1]
                    StatisticsDailyRatioView(title: leftEvent.name, milliseconds: leftMilliseconds, totalMilliseconds: totalMilliseconds, foregroundColor: leftEvent.color)
                }
            }
        }
    }
}

#Preview {
    StatisticsTimeDistributionView()
}

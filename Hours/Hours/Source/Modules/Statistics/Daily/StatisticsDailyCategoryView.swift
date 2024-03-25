//
//  StatisticsDailyCategoryView.swift
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

struct StatisticsDailyCategoryView: View {
    @EnvironmentObject var viewModel: StatisticsViewModel

    var totalMilliseconds: Int { viewModel.dailyTotalMilliseconds }

    var body: some View {
        if #available(iOS 17.0, *) {
            ZStack {
                if totalMilliseconds > 0 {
                    Chart(0 ..< viewModel.dailyCategorys.count, id: \.self) { index in
                        let category = viewModel.dailyCategorys[index]
                        let milliseconds = viewModel.dailyCategoryMilliseconds[index]
                        SectorMark(angle: .value(category.name, milliseconds), innerRadius: .ratio(0.618), angularInset: 1)
                            .cornerRadius(8)
                            .foregroundStyle(category.darkPrimary)
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

    func getMilliseconds(for section: ResultsSection<String, RecordObject>) -> Int {
        var milliseconds = 0
        for record in section {
            milliseconds += record.milliseconds
        }
        return milliseconds
    }

    func getTotalMilliseconds(for results: SectionedResults<String, RecordObject>) -> Int {
        var milliseconds = 0

        for section in results {
            for record in section {
                milliseconds += record.milliseconds
            }
        }
        return milliseconds
    }

    func getRatioView(totalMilliseconds: Int) -> some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 8) {
            let count = viewModel.dailyCategorys.count
            ForEach(0 ..< (count / 2), id: \.self) { index in
                GridRow {
                    let leftEvent = viewModel.dailyCategorys[index * 2]
                    let leftMilliseconds = viewModel.dailyCategoryMilliseconds[index * 2]
                    StatisticsDailyRatioView(title: leftEvent.name, milliseconds: leftMilliseconds, totalMilliseconds: totalMilliseconds, foregroundColor: leftEvent.darkPrimary)

                    let rightEvent = viewModel.dailyEvents[index * 2 + 1]
                    let rightMilliseconds = viewModel.dailyCategoryMilliseconds[index * 2 + 1]
                    StatisticsDailyRatioView(title: rightEvent.name, milliseconds: rightMilliseconds, totalMilliseconds: totalMilliseconds, foregroundColor: rightEvent.darkPrimary)
                }
            }

            if count % 2 == 1 {
                GridRow {
                    let leftEvent = viewModel.dailyCategorys[count - 1]
                    let leftMilliseconds = viewModel.dailyCategoryMilliseconds[count - 1]
                    StatisticsDailyRatioView(title: leftEvent.name, milliseconds: leftMilliseconds, totalMilliseconds: totalMilliseconds, foregroundColor: leftEvent.darkPrimary)
                }
            }
        }
    }
}

#Preview {
    StatisticsDailyCategoryView()
        .environmentObject(StatisticsViewModel())
}

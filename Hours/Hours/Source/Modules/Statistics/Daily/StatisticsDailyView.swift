//
//  StatisticsDailyView.swift
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

struct StatisticsDailyView: View {
    @EnvironmentObject var viewModel: StatisticsViewModel

    var dailyDate: Date { viewModel.dailyDate }

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(R.string.localizable.dailyInput())
                        .font(.title3)
                        .foregroundStyle(Color.secondaryLabel)

                    HStack {
                        Button(action: {
                            withAnimation {
                                let date = dailyDate.dateByAdding(-1, .day).date
                                viewModel.onDailyDateChanged(date)
                            }
                        }) {
                            Image(systemName: "chevron.left.circle")
                                .font(.callout)
                        }

                        Text(dailyDate.toString(.date(.medium)))
                            .font(.body)

                        Button(action: {
                            withAnimation {
                                let date = dailyDate.dateByAdding(1, .day).date
                                viewModel.onDailyDateChanged(date)
                            }
                        }) {
                            Image(systemName: "chevron.right.circle")
                                .font(.callout)
                        }
                        .disabled(dailyDate.isToday)
                        Spacer()
                    }
                    .foregroundStyle(Color.secondaryLabel)
                }

                Spacer()

                Picker(selection: $viewModel.dailyType.animation(), label: Text("Segments")) {
                    ForEach(StatisticsDailyType.allCases) {
                        Text($0.title)
                    }
                }
                .width(120)
                .labelsHidden()
                .pickerStyle(.segmented)
            }
            .padding(.bottom)

            switch viewModel.dailyType {
            case .task:
                StatisticsDailyEventView()
            case .category:
                StatisticsDailyCategoryView()
            }
        }
        .padding()
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }
}

#Preview {
    StatisticsDailyView()
        .environmentObject(StatisticsViewModel())
}
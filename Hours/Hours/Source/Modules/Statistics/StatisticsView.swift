//
//  StatisticsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/5.
//

import Charts
import ExyteGrid
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI
import SwiftUIX

struct StatisticsView: View {
    @ObservedObject var viewModel: StatisticsViewModel = .init()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    HStack(spacing: 16) {
                        StatisticsNumberView(imageName: "list.clipboard", title: R.string.localizable.records(), subtitle: R.string.localizable.total(), fillColor: ui.primary) {
                            Text("\(viewModel.totalRecords)")
                                .font(.title, weight: .bold)
                                .foregroundStyle(Color.label)
                        }

                        StatisticsNumberView(imageName: "hourglass", title: R.string.localizable.timeInvest(), subtitle: R.string.localizable.total(), fillColor: ui.primary) {
                            StatisticsTimeView(time: viewModel.totalMilliseconds.time)
                        }
                    }

                    StatisticsDailyView()
                        .proMask()
                    StatisticsBarView()
                        .proMask()
                    StatisticsTimeDistributionView()
                        .proMask()
                }
                .padding()
                .padding(.bottom)
                .environmentObject(viewModel)
            }
            .background(ui.background)
            .navigationTitle(R.string.localizable.statistics())
        }

    }
}

#Preview {
    StatisticsView()
}

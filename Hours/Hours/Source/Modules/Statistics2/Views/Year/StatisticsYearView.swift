//
//  StatisticsYearView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/1.
//

import ComposableArchitecture
import HoursShare
import SwiftUI

struct StatisticsYearView: View {
    @Perception.Bindable var store: StoreOf<StatisticsYear>

    var body: some View {
        WithPerceptionTracking {
            VStack {
                datePicker
                scrollView
            }
            .onAppear {
                store.send(.onAppear)
            }
            .background(ui.background)
        }
    }

    var datePicker: some View {
        StatisticsDatePicker(
            previous: store.startAt <= app.initialDate ? nil : { store.send(.previous, animation: .default) },
            next: store.isThisYear ? nil : { store.send(.next, animation: .default) }
        ) {
            let yearString = "\(store.startAt.year)"
            let thisYearString = R.string.localizable.thisYear(yearString)
            return Text(store.isThisYear ? thisYearString : yearString)
                .font(.headline)
                .frame(.greedy)
        }
    }

    @ViewBuilder var scrollView: some View {
        if let records = store.records {
            ScrollView {
                contentView(for: records)
            }
        } else {
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(ui.label)
                Spacer()
            }
        }
    }

    func contentView(for records: [RecordEntity]) -> some View {
        LazyVStack {
            HStack(spacing: 16) {
                let iconForegroundColor = store.compositions.first?.event.primary ?? .white
                let fillColor = store.compositions.first?.event.primaryContainer ?? ui.primary
                StatisticsNumberView(imageName: "list.clipboard", title: R.string.localizable.records(), subtitle: R.string.localizable.total(), iconForegroundColor: iconForegroundColor, iconBackgound: fillColor) {
                    Text("\(store.totalCount)")
                        .font(.title, weight: .bold)
                        .foregroundStyle(Color.label)
                }

                StatisticsNumberView(imageName: "hourglass", title: R.string.localizable.timeInvest(), subtitle: R.string.localizable.total(), iconForegroundColor: iconForegroundColor, iconBackgound: fillColor) {
                    StatisticsTimeView(time: store.totalMilliseconds.time)
                }
            }

            StatisticsSection(title: R.string.localizable.overall()) {
                StatisticsCompositionView(
                    compositions: store.compositions,
                    totalMilliseconds: store.totalMilliseconds,
                    isOverallDayExpanded: $store.isOverallDayExpanded.animation()
                )
            }

            StatisticsSection(title: R.string.localizable.heatMap()) {
                StatisticsYearHeatMapView(
                    contributions: store.contributions,
                    months: store.contributionMonths,
                    maxMilliseconds: store.contributionMaxMilliseconds
                )
            }

            StatisticsSection(title: R.string.localizable.timeDistribution()) {
                StatisticsYearTimeDistributionView(
                    timeDistributions: store.timeDistributions
                )
            }
        }
        .padding()
    }
}

#Preview {
    StatisticsYearView(
        store: StoreOf<StatisticsYear>(
            initialState: StatisticsYear.State(),
            reducer: { StatisticsYear() }
        )
    )
}

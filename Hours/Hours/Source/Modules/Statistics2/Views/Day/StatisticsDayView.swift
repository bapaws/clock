//
//  StatisticsDayView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/31.
//

import ComposableArchitecture
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI

struct StatisticsDayView: View {
    @Perception.Bindable var store: StoreOf<StatisticsDay>

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
            next: store.isToday ? nil : { store.send(.next, animation: .default) }
        ) {
            Group {
                if store.isToday || store.isYesterday {
                    VStack {
                        Text(store.isToday ? R.string.localizable.today() : R.string.localizable.yesterday())
                            .font(.headline)
                        Text(store.startAt.toString(.date(.medium)))
                            .font(.subheadline)
                    }
                } else {
                    Text(store.startAt.toString(.date(.medium)))
                        .font(.headline)
                }
            }
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

            StatisticsSection(title: R.string.localizable.timeDistribution()) {
                StatisticsDayTimeDistributionView(timeDistributions: store.timeDistributions)
            }

            StatisticsSection(title: R.string.localizable.heatMap()) {
                StatisticsDayHeatMapView(heatMaps: store.heatMaps)
            }
        }
        .padding()
    }
}

#Preview {
    StatisticsDayView(
        store: StoreOf<StatisticsDay>(
            initialState: StatisticsDay.State(),
            reducer: { StatisticsDay() }
        )
    )
}

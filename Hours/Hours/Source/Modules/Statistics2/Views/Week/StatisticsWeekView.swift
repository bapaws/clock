//
//  StatisticsWeekView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/1.
//

import ComposableArchitecture
import HoursShare
import SwiftUI

struct StatisticsWeekView: View {
    @Perception.Bindable var store: StoreOf<StatisticsWeek>

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
            next: store.isThisWeek ? nil : { store.send(.next, animation: .default) }
        ) {
            VStack {
                let weekString = L10n.weekOfYear("\(store.startAt.year)", "\(store.startAt.weekOfYear)")
                Text(store.isThisWeek ? L10n.thisWeek(weekString) : weekString)
                    .font(.headline)
                Text(store.startAt.to(format: "MMMd") + " ~ " + store.endAt.to(format: "MMMd"))
                    .font(.subheadline)
            }
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
                StatisticsNumberView(imageName: "list.clipboard", title: L10n.records, subtitle: L10n.total, iconForegroundColor: iconForegroundColor, iconBackgound: fillColor) {
                    Text("\(store.totalCount)")
                        .font(.title, weight: .bold)
                        .foregroundStyle(Color.label)
                }

                StatisticsNumberView(imageName: "hourglass", title: L10n.timeInvest, subtitle: L10n.total, iconForegroundColor: iconForegroundColor, iconBackgound: fillColor) {
                    StatisticsTimeView(time: store.totalMilliseconds.time)
                }
            }

            StatisticsSection(title: L10n.overall) {
                StatisticsCompositionView(
                    compositions: store.compositions,
                    totalMilliseconds: store.totalMilliseconds,
                    maxAngularCount: store.maxAngularCount,
                    isOverallDayExpanded: $store.isOverallDayExpanded.animation()
                )
                .proMask()
            }

            StatisticsSection(title: L10n.heatMap) {
                StatisticsWeekHeatMapView(
                    heatMapTimeInterval: store.heatMapTimeInterval,
                    heatMaps: store.heatMaps
                )
                .proMask()
            }

            StatisticsSection(title: L10n.timeDistribution) {
                StatisticsWeekTimeDistributionView(
                    timeDistributions: store.timeDistributions
                )
                .proMask()
            }
        }
        .padding()
    }
}

#Preview {
    StatisticsWeekView(
        store: StoreOf<StatisticsWeek>(
            initialState: StatisticsWeek.State(),
            reducer: { StatisticsWeek() }
        )
    )
}

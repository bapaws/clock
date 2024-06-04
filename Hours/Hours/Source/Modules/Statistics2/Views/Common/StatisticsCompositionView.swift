//
//  StatisticsCompositionView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/1.
//

import Charts
import ComposableArchitecture
import SwiftUI
import SwiftUIX

struct StatisticsCompositionView: View {
    let compositions: IdentifiedArrayOf<StatisticsOverallDay>
    let totalMilliseconds: Int
    @Binding var isOverallDayExpanded: Bool

    var body: some View {
        VStack {
            if #available(iOS 17.0, *) {
                ZStack {
                    let lineWidth = 250 * (1 - 0.618) / 2
                    if totalMilliseconds > 0 {
                        Chart(compositions) { item in
                            SectorMark(
                                angle: .value(item.event.name, item.totalMilliseconds),
                                innerRadius: .ratio(0.618),
                                angularInset: 1
                            )
                            .cornerRadius(8)
                            .foregroundStyle(item.event.primaryContainer)
                        }
                    } else {
                        Circle()
                            .stroke(ui.background, style: StrokeStyle(lineWidth: lineWidth))
                            .frame(width: 250 - lineWidth / 2 - 24, height: 250 - lineWidth / 2 - 24, alignment: .center)
                    }

                    VStack {
                        Text(R.string.localizable.totalInvest())
                            .font(.footnote)
                            .foregroundStyle(Color.secondaryLabel)
                        Text(totalMilliseconds.shortTimeLengthText)
                            .font(.title)
                    }
                    .frame(.greedy)
                }
                .height(250)
                .padding(.bottom)
            }

            if totalMilliseconds > 0 {
                ratioView
            }

            if compositions.count > 6 {
                Button {
                    isOverallDayExpanded.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Spacer()
                        Text(isOverallDayExpanded ? R.string.localizable.collapse() : R.string.localizable.expand())
                        Image(systemName: "chevron.forward")
                            .rotationEffect(isOverallDayExpanded ? .degrees(-90) : .zero)
                        Spacer()
                    }
                    .foregroundStyle(ui.secondary)
                    .font(.footnote)
                    .padding(.top)
                }
                .frame(alignment: .leading)
            }
        }
        .padding()
    }

    var ratioView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            let showExpandButton = compositions.count > 6
            let count = showExpandButton && !isOverallDayExpanded ? 6 : compositions.count
            ForEach(0 ..< count, id: \.self) { index in
                let leftEvent = compositions[index].event
                let leftMilliseconds = compositions[index].totalMilliseconds
                StatisticsDailyRatioView(
                    title: leftEvent.name,
                    milliseconds: leftMilliseconds,
                    totalMilliseconds: totalMilliseconds,
                    foregroundColor: leftEvent.darkPrimary
                )
            }
        }
    }
}

#Preview {
    StatisticsCompositionView(
        compositions: IdentifiedArrayOf<StatisticsOverallDay>(),
        totalMilliseconds: 100,
        isOverallDayExpanded: .constant(false)
    )
}

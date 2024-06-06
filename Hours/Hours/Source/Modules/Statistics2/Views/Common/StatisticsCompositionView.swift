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
            let height: CGFloat = 250
            ZStack {
                let lineWidth = 20.0
                let radius = height / 2 - lineWidth / 2
                if totalMilliseconds > 0 {
                    GeometryReader { proxy in
                        let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
                        ForEach(compositions) { item in
                            Path { path in
                                path.addArc(center: center, radius: radius, startAngle: .degrees(item.startAngle), endAngle: .degrees(item.endAngle), clockwise: false)
                            }
                            .stroke(
                                item.event.primaryContainer,
                                style: StrokeStyle(
                                    lineWidth: lineWidth,
                                    lineCap: .round
                                )
                            )
                        }
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
            .height(height)
            .padding(.bottom)

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

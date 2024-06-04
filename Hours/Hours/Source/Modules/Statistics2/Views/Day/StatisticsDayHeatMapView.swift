//
//  StatisticsDayHeatMapView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/31.
//

import Foundation
import HoursShare
import Perception
import SwiftUI
import SwiftUIX

struct StatisticsDayHeatMapView: View {
    let heatMaps: [StatisticsHeatMap]

    let rowHeight: CGFloat = 24
    let hourWidth: CGFloat = 48

    var body: some View {
        VStack {
            header

            HStack {
                grid(for: 0 ..< heatMaps.count / 2)

                LazyVStack {
                    ForEach(0 ..< 12, id: \.self) { index in
                        Text(index == 0 ? "0/12" : "\(index)")
                    }
                    .monospacedDigit()
                    .frame(width: hourWidth, height: rowHeight)
                }
                .foregroundStyle(ui.secondaryLabel)
                .frame(width: hourWidth)

                grid(for: heatMaps.count / 2 ..< heatMaps.count)
            }
        }
        .padding()
    }

    private var header: some View {
        HStack {
            Spacer()
            Text(R.string.localizable.aM())
            Spacer()
            ui.secondaryBackground
                .frame(width: hourWidth)
            Spacer()
            Text(R.string.localizable.pM())
            Spacer()
        }
        .padding(.vertical, .small)
        .foregroundStyle(ui.secondaryLabel)
    }

    private func grid(for range: Range<Int>) -> some View {
        GeometryReader { proxy in
            let dimension = (proxy.size.width - 3 * 8) / 4
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(dimension)), count: 4)) {
                ForEach(range, id: \.self) { index in
                    Group {
                        if let event = heatMaps[index].record?.event, let hex = event.hex {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(hex.primaryContainer)

                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(ui.background)
                        }
                    }
                }
                .frame(height: rowHeight)
            }
        }
    }
}

#Preview {
    StatisticsDayHeatMapView(
        heatMaps: [
        ]
    )
}

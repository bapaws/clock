//
//  StatisticsBarView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/14.
//

import Charts
import SwiftUI
import SwiftUIX

struct StatisticsBarView: View {
    @EnvironmentObject var viewModel: StatisticsViewModel

    var body: some View {
        VStack(spacing: 32) {
            Picker(selection: $viewModel.barSelection.animation()) {
                ForEach(StatisticsBarType.allCases) {
                    Text($0.title)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)

            Chart(viewModel.barValues) { value in
                BarMark(
                    x: .value("Title", value.title),
                    y: .value("Hours", value.hours),
                    width: .automatic
                )
                .cornerRadius(8)
                .foregroundStyle(value.color)
            }
            .chartYAxis {
                AxisMarks {
                    AxisGridLine()
                    AxisTick()
                    let text = $0.as(Int.self)!
                    AxisValueLabel {
                        Text("\(text)h")
                    }
                }
            }
            .height(250)
        }
        .padding()
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }
}

#Preview {
    StatisticsBarView()
}

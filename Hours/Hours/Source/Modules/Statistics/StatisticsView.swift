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

enum TaskStatisticsType: CaseIterable, Identifiable {
    case task, category

    var id: TaskStatisticsType { self }

    var title: String {
        switch self {
        case .task:
            R.string.localizable.task()
        case .category:
            R.string.localizable.category()
        }
    }
}

struct StatisticsView: View {
    @State var dailyDate: Date = .init()
    @State var dailyTaskStatisticsType: TaskStatisticsType = .task

    @State var currentDate: Date = .init()

    let weekdaySymbols = DateFormatter().shortWeekdaySymbols!

    @State var events: Results<EventObject> = DBManager.default.events
    var minCreateAt: Date {
        DBManager.default.minCreateAt
    }

    var totalMilliseconds: Int {
        DBManager.default.totalMilliseconds
    }

    var totalTime: EventTime {
        totalMilliseconds.time
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    StatisticsNumberView(title: "Tasks", subtitle: "Total", fillColor: Color.mint) {
                        Text("\(events.count)")
                            .font(.title, weight: .bold)
                            .foregroundStyle(Color.label)
                    }
                    StatisticsNumberView(title: "Active Days", subtitle: "Average", fillColor: Color.mint) {
                        StatisticsTimeView(time: totalTime)
                    }
                }

                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Daily")
                                .font(.title3)
                                .foregroundStyle(Color.secondaryLabel)

                            HStack {
                                Button(action: {}) {
                                    Image(systemName: "chevron.left.circle")
                                        .font(.callout)

                                }
                                .disabled(dailyDate.compare(.isSameDay(minCreateAt)))

                                Text(dailyDate.toString(.date(.medium)))
                                    .font(.body)

                                Button(action: {}) {
                                    Image(systemName: "chevron.right.circle")
                                        .font(.callout)
                                }
                                .disabled(dailyDate.isToday)
                                Spacer()
                            }
                            .foregroundStyle(Color.secondaryLabel)
                        }

                        Spacer()

                        Picker(selection: $dailyTaskStatisticsType, label: Text("Segments")) {
                            ForEach(TaskStatisticsType.allCases) {
                                Text($0.title)
                            }
                        }
                        .width(120)
                        .labelsHidden()
                        .pickerStyle(.segmented)
                    }

                    Color.tertiarySystemBackground
                        .height(16)

                    if #available(iOS 17.0, *) {
                        ZStack {
                            Chart(events) {
                                SectorMark(angle: .value("milliseconds", $0.milliseconds), innerRadius: .ratio(0.618), angularInset: 2)
                                    .cornerRadius(8)
                                    .foregroundStyle($0.color)
                            }
                            .height(250)
                            VStack {
                                Text("Total Invest")
                                Text("")
                            }
                        }

                        Color.tertiarySystemBackground
                            .height(16)
                    }

                    ForEach(events) { task in
                        HStack {
                            if let category = task.category {
                                CategoryView(category: category)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(task.name)
                                    Spacer()
                                    Text(task.milliseconds.shortTimeLengthText)
                                }
                                .font(.footnote, weight: .bold)

                                GeometryReader { proxy in
                                    HStack {
                                        let ratio = CGFloat(task.milliseconds) / CGFloat(totalMilliseconds)
                                        let capsuleWidth = proxy.size.width - 64 - 8
                                        Capsule()
                                            .foregroundStyle(Color.secondarySystemBackground)
                                            .frame(width: capsuleWidth, height: 8)
                                            .overlay(alignment: .leading) {
                                                Capsule()
                                                    .foregroundStyle(task.color)
                                                    .frame(width: capsuleWidth * ratio, height: 8)
                                            }
                                        Text(String(format: "%.1f%%", ratio * 100))
                                            .font(.caption)
                                            .foregroundStyle(Color.tertiaryLabel)
                                            .frame(width: 64, alignment: .trailing)
                                    }
                                }
                            }
                            .height(32)
                        }
                        .height(32)
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.tertiarySystemBackground)
                }

                HStack {
                    VStack(spacing: 8) {
                        Text("1h23min")
                            .font(.title, weight: .bold)
                            .foregroundStyle(Color.white)
                        Text("Total time")
                            .foregroundStyle(Color.white)
                            .font(.callout)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.mint)
                    }
                }
                .frame(height: 200)
            }
            .padding()
        }
        .background(Color.secondarySystemBackground)
//        .onAppear {
//            var milliseconds = 0
//            for task in events {
//                milliseconds += task.milliseconds
//            }
//            let time = milliseconds.time
//            print(milliseconds)
//        }
    }
}

#Preview {
    StatisticsView()
}

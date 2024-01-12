//
//  ClockProvider.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/10.
//

import ClockShare
import Foundation
import SwiftDate
import SwiftUI
import SwiftUIX
import WidgetKit

struct ClockProvider: TimelineProvider {
    func placeholder(in context: Context) -> Time {
        Time(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (Time) -> ()) {
        let entry = Time(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Time>) -> ()) {
        let currentDate = Date()
        var entries: [Time] = [Time(date: currentDate)]

        let nextDate = currentDate.addingTimeInterval(TimeInterval(60 - currentDate.second))
        for minuteOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: nextDate)!
            let entry = Time(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

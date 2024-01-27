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

struct ClockTimelineEntry: TimelineEntry {
    let time: Time
    let isPreview: Bool

    init(time: Time, isPreview: Bool) {
        self.time = time
        self.isPreview = isPreview
    }

    init(date: Date, isPreview: Bool) {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        self.time = Time(date: date.addingTimeInterval(-0.00001), hour: components.hour!, minute: components.minute!, second: 0)
        self.isPreview = isPreview
    }

    var date: Date {
        time.date
    }
}

struct ClockProvider: TimelineProvider {
    typealias Entry = ClockTimelineEntry

    func placeholder(in context: Context) -> Entry {
        ClockTimelineEntry(date: Date(), isPreview: context.isPreview)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        completion(ClockTimelineEntry(date: Date(), isPreview: context.isPreview))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date().dateBySet([.second: 0, .nanosecond: 0])!
        var entries = [ClockTimelineEntry(date: currentDate, isPreview: context.isPreview)]

        // 按秒刷新，到一定的次数，时钟不再刷新
        for minuteOffset in 1 ..< 60 {
            let entryDate = currentDate.addingTimeInterval(TimeInterval(minuteOffset * 60))
            let entry = ClockTimelineEntry(date: entryDate, isPreview: context.isPreview)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

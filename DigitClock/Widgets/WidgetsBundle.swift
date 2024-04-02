//
//  WidgetsBundle.swift
//  Widgets
//
//  Created by 张敏超 on 2024/1/26.
//

import SwiftUI
import WidgetKit

@main
struct WidgetsBundle: WidgetBundle {
    @WidgetBundleBuilder var body: some Widget {
        ClockVipWidgetBundle().body

        ClockFreeWidgetBundle().body

        if #available(iOSApplicationExtension 16.1, *) {
            PomodoroWidgetLiveActivity()
        }
    }
}

struct ClockVipWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockSmallWidget(secondStyle: .small)
        ClockSmallWidget(secondStyle: .small, colorScheme: .dark)

        ClockMediumWidget(secondStyle: .big)
        ClockMediumWidget(secondStyle: .big, colorScheme: .dark)

        TimeRecordClockWidget()
        TimeRecordClockWidget(colorScheme: .dark)
    }
}

struct ClockFreeWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockSmallWidget()
        ClockSmallWidget(colorScheme: .dark)

        ClockMediumWidget()
        ClockMediumWidget(colorScheme: .dark)
    }
}

struct ClockSmallWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockSmallWidget()
        ClockSmallWidget(secondStyle: .small)

        ClockSmallWidget(colorScheme: .dark)
        ClockSmallWidget(secondStyle: .small, colorScheme: .dark)
    }
}

struct ClockMediumWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockMediumWidget()
        ClockMediumWidget(secondStyle: .big)

        ClockMediumWidget(colorScheme: .dark)
        ClockMediumWidget(secondStyle: .big, colorScheme: .dark)
    }
}

struct TimeRecordWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder var body: some Widget {
        TimeRecordClockWidget()
        TimeRecordClockWidget(colorScheme: .dark)
    }
}

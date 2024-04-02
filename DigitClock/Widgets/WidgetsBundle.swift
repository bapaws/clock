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
        ClockSmallWidgetBundle().body

        ClockMediumWidgetBundle().body

        TimeRecordWidgetBundle().body

        if #available(iOSApplicationExtension 16.1, *) {
            PomodoroWidgetLiveActivity()
        }
    }
}

struct ClockSmallWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockSmallWidget()
        ClockSmallWidget(secondStyle: .small)
    }
}

struct ClockMediumWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockMediumWidget()
        ClockMediumWidget(secondStyle: .big)
    }
}

struct TimeRecordWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder var body: some Widget {
        TimeRecordClockWidget()
        TimeRecordClockWidget(secondStyle: .none)
    }
}

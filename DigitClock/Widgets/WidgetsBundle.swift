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
        ClockMediumWidget(secondStyle: .big)

        TimeRecordClockWidget()
    }
}

struct ClockFreeWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockSmallWidget()
        ClockMediumWidget()
    }
}

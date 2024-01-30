//
//  DeskClockWidgetBundle.swift
//  DeskClockWidget
//
//  Created by 张敏超 on 2024/1/9.
//

import SwiftUI
import WidgetKit

@main
struct DeskClockWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockWidget()
        if #available(iOSApplicationExtension 16.1, *) {
            PomodoroWidgetLiveActivity()
        }
    }
}

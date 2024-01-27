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
    var body: some Widget {
        ClockSmallWidget()
        ClockSmallWidget(secondStyle: .small)
        ClockMediumWidget()
        ClockMediumWidget(secondStyle: .big)

        ClockSmallWidget(colorScheme: .dark)
        ClockSmallWidget(secondStyle: .small, colorScheme: .dark)
        ClockMediumWidget(colorScheme: .dark)
        ClockMediumWidget(secondStyle: .big, colorScheme: .dark)

        if #available(iOSApplicationExtension 16.1, *) {
            PomodoroWidgetLiveActivity()
        }
    }
}

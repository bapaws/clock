//
//  WidgetsBundle.swift
//  Widgets
//
//  Created by 张敏超 on 2024/5/22.
//

import ClockShare
import HoursShare
import SwiftUI
import WidgetKit

@main
@available(iOS 16.1, *)
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        TimerLiveActivity()

        if #available(iOSApplicationExtension 17.0, *) {
            QuickMediumWidget()
            QuickLargeWidget()
        }
    }
}

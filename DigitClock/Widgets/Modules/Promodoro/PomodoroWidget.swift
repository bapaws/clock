//
//  PomodoroWidget.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/10.
//

import ClockShare
import DigitalClockShare
import SwiftUI
import SwiftUIX
import WidgetKit

@available(iOSApplicationExtension 16.1, *)
struct PomodoroWidget: View {
    let context: ActivityViewContext<PomodoroAttributes>

    var body: some View {
        Text(timerInterval: context.state.range, countsDown: true, showsHours: true)
            .monospacedDigit()
            .font(.system(size: 75, design: .rounded), weight: .ultraLight)
            .minimumScaleFactor(0.2)
    }
}

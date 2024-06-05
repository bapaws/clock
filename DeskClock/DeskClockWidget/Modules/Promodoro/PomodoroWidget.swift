//
//  PomodoroWidget.swift
//  DeskClock
//
//  Created by 张敏超 on 2024/1/10.
//

import ClockShare
import DeskClockShare
import SwiftUI
import SwiftUIX
import WidgetKit

@available(iOSApplicationExtension 16.1, *)
struct PomodoroWidget: View {
    let context: ActivityViewContext<PomodoroAttributes>

    var padding: CGFloat = 16
    var spacing: CGFloat = 4
    var colonWidth: CGFloat = 16
    var digitWidth: CGFloat = 96

    var body: some View {
        Text(timerInterval: context.state.range, countsDown: true, showsHours: true)
            .monospacedDigit()
            .foregroundColor(context.attributes.colors.primary)
    }
}

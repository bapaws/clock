//
//  TimeRecordClockEntryView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/4/2.
//

import ClockShare
import DigitalClockShare
import SwiftUI

struct TimeRecordClockEntryView: View {
    var entry: ClockProvider.Entry
    var secondStyle: DigitStyle = .none

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var ui: UIManager

    var body: some View {
        TimeRecordClock(time: entry.time)
            .proMask(isPreview: entry.isPreview)
            .containerBackground(ui.background)
    }
}

#Preview {
    TimeRecordClockEntryView(entry: ClockProvider.Entry(date: Date(), isPreview: true))
}

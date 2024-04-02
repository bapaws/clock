//
//  ClockEntryView.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/1/27.
//

import ClockShare
import DigitalClockShare
import Foundation
import SwiftDate
import SwiftUI
import SwiftUIX
import WidgetKit

struct ClockEntryView: View {
    var entry: ClockProvider.Entry
    var secondStyle: DigitStyle = .none

    @EnvironmentObject var ui: UIManager
    @Environment(\.widgetFamily) var widgetFamily

    var clock: ClockManager { ClockManager.shared }

    let digitCount: CGFloat = 2
    /// default small widget font size
    var fontSize: CGFloat = 54
    /// default small widget date font size
    var dateFontSize: CGFloat = 18
    /// default small widget second font size
    var secondFontSize: CGFloat = 24

    var time: Time { entry.time }

    var digitBoundingSize: CGSize {
        let font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .ultraLight)
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 10)
        return "00".boundingSize(with: constraintRect, font: font)
    }

    var secondDigitBoundingSize: CGSize {
        let font = UIFont.monospacedDigitSystemFont(ofSize: secondFontSize, weight: .ultraLight)
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 10)
        return "00".boundingSize(with: constraintRect, font: font)
    }

    var body: some View {
        content
            .proMask(isPreview: entry.isPreview)
            .containerBackground(ui.background)
    }

    var content: some View {
        VStack(spacing: 6) {
            Spacer()
            Text(entry.date.to(format: "MMdd, EE"))
                .font(.system(size: 18, design: .rounded), weight: .ultraLight)
                .multilineTextAlignment(.trailing)

            let digitSize = digitBoundingSize
            GeometryReader { proxy in
                let spacing = floor(proxy.size.width - digitCount * digitSize.width) / 3

                HStack(spacing: spacing) {
                    ui.background
                    DigitView(tens: time.hourTens, ones: time.hourOnes)
                        .frame(digitSize)

                    DigitView(tens: time.minuteTens, ones: time.minuteOnes)
                        .frame(digitSize)
                    ui.background
                }
            }
            .height(digitSize.height)

            if secondStyle != .none {
                let secondSize = secondDigitBoundingSize
                Text(entry.date, style: .timer)
                    .font(.system(size: secondFontSize, design: .rounded), weight: .ultraLight)
                    .multilineTextAlignment(.trailing)
                    .monospacedDigit()
                    .overlay {
                        GeometryReader { proxy in
                            ui.colors.background
                                .frame(width: proxy.size.width - secondSize.width, height: secondSize.height)
                        }
                    }
                    .padding(.horizontal)
            }
            Spacer()
        }
        .font(.system(size: fontSize, design: .rounded), weight: .ultraLight)
        .padding(.vertical)
        .background(ui.background)
    }
}

#Preview {
    ClockEntryView(entry: ClockTimelineEntry(date: Date(), isPreview: true))
}

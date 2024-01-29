//
//  ClockMediumEntryView.swift
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

struct ClockMediumEntryView: View {
    var entry: ClockProvider.Entry
    var secondStyle: DigitStyle = .big

    @EnvironmentObject var ui: DigitalClockShare.UIManager
    @Environment(\.widgetFamily) var widgetFamily
    var clock: ClockManager { ClockManager.shared }

    let padding: CGFloat = 32
    var digitCount: CGFloat {
        secondStyle == .none ? 2 : 3
    }

    let fontSize: CGFloat = 72

    var digitBoundingSize: CGSize {
        let font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .ultraLight)
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 10)
        return "00".boundingSize(with: constraintRect, font: font)
    }

    var time: Time { entry.time }

    var body: some View {
        Group {
            if !entry.isPreview, secondStyle != .none, !ProManager.default.isPro {
                ZStack {
                    content
                    Color.black
                        .frame(.greedy)
                        .opacity(0.6)
                    Image(systemName: "crown")
                        .foregroundStyle(Color.systemOrange)
                        .font(.title)
                }
            } else {
                content
            }
        }
        .containerBackground(ui.background)
    }

    @ViewBuilder var content: some View {
        VStack {
            Spacer()
            Text(entry.date, style: .date)
                .font(.system(size: fontSize / 4, design: .rounded), weight: .ultraLight)
            clockView
            Spacer()
        }
        .background(ui.background)
    }

    @ViewBuilder var clockView: some View {
        let digitSize = digitBoundingSize
        GeometryReader { proxy in
            if secondStyle == .none {
                HStack {
                    Spacer()
                    DigitView(tens: time.hourTens, ones: time.hourOnes)
                        .frame(digitSize)
                    Spacer()
                    DigitView(tens: time.minuteTens, ones: time.minuteOnes)
                        .frame(digitSize)
                    Spacer()
                }
            } else {
                let spacing = (proxy.size.width - digitCount * digitSize.width) / (digitCount + 1)
                ZStack(alignment: .leading) {
                    Text(entry.date, style: .timer)
                        .multilineTextAlignment(.trailing)
                        .monospacedDigit()
                        .overlay {
                            GeometryReader { proxy in
                                ui.colors.background
                                    .frame(width: proxy.size.width - digitSize.width, height: digitSize.height)
                            }
                        }
                        .offset(x: -spacing)

                    HStack(spacing: spacing) {
                        DigitView(tens: time.hourTens, ones: time.hourOnes)
                            .frame(digitSize)

                        DigitView(tens: time.minuteTens, ones: time.minuteOnes)
                            .frame(digitSize)
                    }
                    .frame(alignment: .leading)
                    .offset(x: spacing)
                }
            }
        }
        .font(.system(size: fontSize, design: .rounded), weight: .ultraLight)
        .height(digitSize.height)
    }
}

#Preview {
    ClockMediumEntryView(entry: ClockTimelineEntry(date: Date(), isPreview: true))
}

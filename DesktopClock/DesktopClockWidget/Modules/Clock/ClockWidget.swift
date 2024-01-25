//
//  ClockWidget.swift
//  DesktopClockWidget
//
//  Created by 张敏超 on 2024/1/9.
//

import ClockShare
import DesktopClockShare
import Neumorphic
import SwiftDate
import SwiftUI
import SwiftUIX
import WidgetKit

struct ClockWidgetEntryView: View {
    var entry: ClockProvider.Entry

    @EnvironmentObject var ui: DesktopClockShare.UIManager

    @Environment(\.widgetFamily) var widgetFamily

    var padding: CGFloat {
        switch widgetFamily {
        case .systemSmall:
            8
        case .systemMedium:
            16
        case .systemLarge:
            16
        default:
            16
        }
    }

    var spacing: CGFloat {
        switch widgetFamily {
        case .systemSmall:
            4
        case .systemMedium:
            16
        case .systemLarge:
            16
        default:
            16
        }
    }

    var colonWidth: CGFloat {
        switch widgetFamily {
        case .systemSmall:
            12
        case .systemMedium:
            24
        case .systemLarge:
            28
        default:
            24
        }
    }

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min((proxy.size.width - colonWidth - spacing * 2) / 2, proxy.size.height)
            VStack {
                Spacer()
                top
                Spacer()
                HStack(spacing: spacing) {
                    DigitView(tens: entry.hourTens, ones: entry.hourOnes, colorType: ui.colorType)
                        .frame(width: digitWidth, height: digitWidth)
                    ColonView(colorType: ui.colorType)
                        .frame(width: colonWidth, height: digitWidth)
                    DigitView(tens: entry.minuteTens, ones: entry.minuteOnes, colorType: ui.colorType)
                        .frame(width: digitWidth, height: digitWidth)
                }
                Spacer()
                bottom
                Spacer()
            }
            .font(.system(size: digitWidth * 0.6, design: .rounded), weight: .bold)
            .minimumScaleFactor(0.2)
            .foregroundColor(ui.primary)
            .frame(.greedy)
        }
        .padding(.horizontal, padding)
        .containerBackground(ui.background)
        .ifLet(UIManager.shared.darkMode.raw) {
            $0.environment(\.colorScheme, $1)
        }
    }

    @ViewBuilder var top: some View {
        switch widgetFamily {
        case .systemSmall:
            Text(entry.date, style: .date)
                .font(.subheadline, weight: .thin)
        case .systemLarge:
            Text(entry.date, style: .date)
                .font(.title, weight: .thin)
        default:
            EmptyView()
        }
    }

    @ViewBuilder var bottom: some View {
        switch widgetFamily {
        case .systemLarge:
            let imageName = "\(ui.colorType.rawValue)\(ui.darkMode.raw == .dark ? "Dark" : "Light")"
            Image(imageName)
        default:
            EmptyView()
        }
    }
}

struct ClockWidget: Widget {
    let kind: String = "DesktopClockWidget"

    @Environment(\.colorScheme) var colorScheme

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockProvider()) { entry in
            ClockWidgetEntryView(entry: entry)
                .environmentObject(UIManager.shared)
                .onAppear {
                    UIManager.shared.setupColors(scheme: colorScheme)
                }
        }
        .disableContentMarginsIfNeeded()
        .configurationDisplayName("Clock")
        .description("This is an clock widget.")
    }
}

@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    ClockWidget()
} timeline: {
    Time(date: .now)
}

@available(iOS 17.0, *)
#Preview(as: .systemMedium) {
    ClockWidget()
} timeline: {
    Time(date: .now)
}

@available(iOS 17.0, *)
#Preview(as: .systemLarge) {
    ClockWidget()
} timeline: {
    Time(date: .now)
}

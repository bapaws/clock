//
//  QuickTimerView.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/6.
//

import ClockShare
import HoursShare
import RealmSwift
import SwiftUI
import SwiftUIX
import UIKit

@available(iOSApplicationExtension 17.0, *)
struct QuickTimerView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let date: Date
    private let event: TimingEntity

    init(date: Date, event: TimingEntity) {
        self.date = date
        self.event = event
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                if let emoji = event.emoji {
                    Text(emoji)
                        .font(.title2)
                }
                Text(event.name)
                    .font(.title2)
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(event.darkPrimary)
                Spacer()
            }
            HStack {
                Text(timerInterval: date ... date.addingTimeInterval(12 * 60 * 60), countsDown: false)
                    .contentTransition(.numericText(countsDown: false))
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .foregroundStyle(event.darkPrimary)
                    .monospacedDigit()

                Spacer()

                stopButton(for: event)
            }
        }
        .padding()
        .frame(.greedy)
        .background(linearGradient)
    }

    @ViewBuilder func stopButton(for event: TimingEntity) -> some View {
        Button(intent: QuickStopTimerAppIntent(), label: {
            Image(systemName: "stop.fill")
                .font(.title2)
                .frame(width: 60, height: 60)
                .foregroundStyle(event.darkPrimary)
                .background(event.darkOnPrimary)
                .cornerRadius(30)
        })
        .background(.clear)
        .buttonStyle(BorderlessButtonStyle())
    }

    private func buttonLabel(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.title3)
            .padding().padding(.small)
            .foregroundStyle(colorScheme == .dark ? event.onPrimary : event.primary)
            .background {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .foregroundStyle(colorScheme == .dark ? event.onPrimaryContainer : event.primaryContainer)
            }
    }

    private var linearGradient: LinearGradient {
        if colorScheme == .dark {
            LinearGradient(gradient: Gradient(colors: [event.primaryContainer, event.primaryContainer]), startPoint: .leading, endPoint: .trailing)
        } else {
            LinearGradient(gradient: Gradient(colors: [event.primaryContainer, event.background]), startPoint: .leading, endPoint: .trailing)
        }
    }
}

#Preview {
    if #available(iOSApplicationExtension 17.0, *) {
        return QuickTimerView(date: .now, event: TimingEntity.random())
    } else {
        return EmptyView()
    }
}

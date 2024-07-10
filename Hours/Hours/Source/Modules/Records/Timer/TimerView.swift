//
//  TimerView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/6.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import RealmSwift
import SwiftUI
import SwiftUIX
import UIKit

struct TimerView: View {
//    let entity: TimingEntity
    @Perception.Bindable var store: StoreOf<TimerFeature>

    // Timer Stop from live activity
    let timerStop = NotificationCenter.default
        .publisher(for: TimerManager.shared.timerStop)

    var manager: HoursShare.TimerManager = .shared
    @Environment(\.dismiss) var dismiss

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var app: AppManager

    var entity: TimingEntity { store.entity }
    var time: Time { entity.time }

    var body: some View {
        WithPerceptionTracking {
            VStack {
                HStack {
                    Button {
                        store.send(.minimize)
                    } label: {
                        Image(systemName: "pip")
                            .foregroundStyle(entity.primary)
                            .padding()
                    }
                    Spacer()
                }

                Text(entity.title)
                    .font(.title)
                    .foregroundStyle(entity.primary)
                    .padding(.vertical, .large)

                Spacer()

                HStack {
                    let seconds = entity.time.seconds
                    if manager.hourStyle != .none || entity.time.hour > 0 {
                        Text("\(time.hourTens)\(time.hourOnes)")
                            .foregroundColor(seconds < 3600 ? zeroNumberColor : numberColor)
                        Text(":")
                            .foregroundColor(seconds < 3600 ? zeroNumberColor : numberColor)
                    }

                    Text("\(time.minuteTens)\(time.minuteOnes)")
                        .foregroundColor(seconds < 60 ? zeroNumberColor : numberColor)
                    Text(":")
                        .foregroundColor(seconds < 60 ? zeroNumberColor : numberColor)
                    Text("\(time.secondTens)\(time.secondOnes)")
                        .foregroundColor(seconds == 0 ? zeroNumberColor : numberColor)
                }
                .contentTransition(.numericText(countsDown: true))
                .font(.system(size: 66, design: .rounded), weight: .bold)
                .monospacedDigit()

                Spacer()

                stopButton
                    .frame(width: 64, height: 64)

                Spacer()
            }
            .background(linearGradient)
            .onAppear {
                store.send(.startTimer)
            }
            .onChange(of: store.entity.time.seconds) { newValue in
                if newValue >= Int(app.maximumRecordedTime) {
                    store.send(.onStopped)
                } else {
                    AppManager.shared.playTimer()
                }
            }
            .onReceive(timerStop) { _ in
                store.send(.onStopped)
            }
        }
    }

    var stopButton: some View {
        Button {
            store.send(.onStopped)
        } label: {
            buttonLabel(systemName: "stop")
        }
    }

    func buttonLabel(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.title3)
            .padding().padding(.small)
            .foregroundStyle(colorScheme == .dark ? entity.onPrimary : entity.primary)
            .background {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .foregroundStyle(colorScheme == .dark ? entity.onPrimaryContainer : entity.primaryContainer)
            }
    }

    var zeroNumberColor: Color {
        numberColor.opacity(0.5)
    }

    var numberColor: Color {
        colorScheme == .dark ? entity.onPrimary : entity.primary
    }

    var linearGradient: LinearGradient {
        if colorScheme == .dark {
            LinearGradient(gradient: Gradient(colors: [entity.onPrimary, entity.onPrimaryContainer]), startPoint: .top, endPoint: .bottom)
        } else {
            LinearGradient(gradient: Gradient(colors: [entity.primaryContainer, entity.background]), startPoint: .top, endPoint: .bottom)
        }
    }
}

#Preview {
    TimerView(
        store: StoreOf<TimerFeature>.init(
            initialState: .init(event: EventEntity.random()),
            reducer: {
                TimerFeature()
            }
        )
    )
}

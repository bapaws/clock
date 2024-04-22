//
//  DigitalPomodoroView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/15.
//

import ActivityKit
import ClockShare
import Combine
import DigitalClockShare
import SwiftUI

struct DigitalPomodoroView: View {
    @Binding var isTabHidden: Bool
    @Binding var ignoreTapGesture: Bool
    @StateObject var manager = DigitalClockShare.PomodoroManager.shared
    @EnvironmentObject var ui: UIManager

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 16) {
                if proxy.size.width > proxy.size.height {
                    DigitalPomodoroLandspaceView(time: manager.time, color: ui.colors)
                } else {
                    DigitalPomodoroPortraitView(time: manager.time, color: ui.colors)
                }
                button
                    .height(ui.bottomHeight)
                    .font(.system(.title, design: .rounded), weight: .ultraLight)
                    .animation(.easeIn, value: manager.state)
                    .contentShape(Rectangle())
            }
        }
        .padding()
        .onChange(of: manager.time.seconds) { _ in
            DigitalAppManager.shared.playPomodoro()
        }
        .task {
            if #available(iOS 16.1, *) {
                for activity in Activity<PomodoroAttributes>.activities {
                    await activity.end()
                }
            }
        }
    }

    @ViewBuilder var button: some View {
        if manager.state == .none {
            startButton
        } else if manager.state == .focusCompleted {
            shortBreakButton
        } else {
            stopButton
        }
    }

    var stopButton: some View {
        HoldOnButton(strokeColor: ui.colors.primary, action: {
            ignoreTapGesture = true
            manager.stop()
        }) {
            Image(systemName: "stop")
                .padding()
        }
    }

    var startButton: some View {
        Button(action: {
            ignoreTapGesture = true
            withAnimation {
                isTabHidden = true
            }
            manager.startFocus()
        }) {
            Image(systemName: "play")
        }
    }

    var restartButton: some View {
        Button(action: {
            ignoreTapGesture = true
            manager.restartFocusTimer()
        }) {
            Image(systemName: "goforward")
        }
    }

    var shortBreakButton: some View {
        Button(action: {
            ignoreTapGesture = true
            withAnimation {
                isTabHidden = true
            }
            manager.startShortBreak()
        }) {
            Image(systemName: "cup.and.saucer")
        }
    }
}

#Preview {
    DigitalPomodoroView(isTabHidden: Binding<Bool>.constant(true), ignoreTapGesture: .constant(true))
        .background(UIManager.shared.colors.background)
}

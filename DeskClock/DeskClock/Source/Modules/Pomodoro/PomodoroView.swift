//
//  PomodoroView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/15.
//

import ClockShare
import DeskClockShare
import Combine
import Neumorphic
import SwiftUI
import ActivityKit

struct PomodoroView: View {
    @Binding var isTabHidden: Bool
    @StateObject var manager = DeskClockShare.PomodoroManager.shared
    @EnvironmentObject var ui: UIManager

    var body: some View {
        GeometryReader { proxy in
            if proxy.size.width > proxy.size.height {
                HStack(spacing: 16) {
                    PomodoroLandspaceView(time: manager.time, color: ui.colors)
                    button
                        .animation(.easeIn, value: manager.state)
                }
            } else {
                VStack(spacing: 16) {
                    PomodoroPortraitView(time: manager.time, color: ui.colors)
                    button
                        .animation(.easeIn, value: manager.state)
                }
            }
        }
        .padding()
        .onChange(of: manager.time.seconds) { _ in
            AppManager.shared.playPomodoro()
        }
        .task {
            if #available(iOS 16.1, *) {
                for activity in Activity<DeskClockShare.PomodoroAttributes>.activities {
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
        HoldOnNeumorphicButton(color: ui.colors, action: manager.stop) {
            Image(systemName: "stop")
        }
    }

    var startButton: some View {
        NeumorphicButton(action: {
            withAnimation {
                isTabHidden = true
            }
            manager.startFocus()
        }) {
            Image(systemName: "play")
        }
    }

    var restartButton: some View {
        NeumorphicButton(action: manager.restartFocusTimer) {
            Image(systemName: "goforward")
        }
    }

    var shortBreakButton: some View {
        NeumorphicButton(action: {
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
    PomodoroView(isTabHidden: Binding<Bool>.constant(true))
        .background(UIManager.shared.colors.background)
}

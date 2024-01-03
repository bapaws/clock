//
//  PomodoroView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/15.
//

import ClockShare
import Combine
import Neumorphic
import SwiftUI

struct PomodoroView: View {
    @StateObject var manager = PomodoroManager.shared

    @EnvironmentObject var ui: UIManager

    var body: some View {
        GeometryReader { proxy in
            if proxy.size.width > proxy.size.height {
                HStack(spacing: 16) {
                    PomodoroLandspaceView(time: PomodoroManager.shared.time, color: ui.colors)
                    VStack(spacing: 32) {
                        button
                    }
                    .animation(.easeIn, value: manager.state)
                }
            } else {
                VStack(spacing: 16) {
                    PomodoroPortraitView(time: PomodoroManager.shared.time, color: ui.colors)
                    HStack(spacing: 32) {
                        button
                    }
                    .animation(.easeIn, value: manager.state)
                }
            }
        }
        .padding()
        .onChange(of: manager.time.seconds) { _ in
            AppManager.shared.playPomodoro()
        }
    }

    @ViewBuilder var button: some View {
        if manager.state == .none {
            startButton
        } else if manager.state == .focusCompleted {
            restartButton
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
        NeumorphicButton(action: manager.startFocus) {
            Image(systemName: "play")
        }
    }

    var restartButton: some View {
        NeumorphicButton(action: manager.restartFocusTimer) {
            Image(systemName: "goforward")
        }
    }

    var shortBreakButton: some View {
        NeumorphicButton(action: manager.startShortBreak) {
            Image(systemName: "gamecontroller")
        }
    }
}

#Preview {
    PomodoroView()
        .background(UIManager.shared.colors.background)
}

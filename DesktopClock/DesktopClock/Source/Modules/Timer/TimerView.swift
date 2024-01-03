//
//  TimerView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/17.
//

import ClockShare
import Combine
import SwiftUI

struct TimerView: View {
    @Binding var isTabHidden: Bool
    @StateObject var manager = TimerManager.shared
    @EnvironmentObject var ui: UIManager

    var body: some View {
        GeometryReader { proxy in
            if proxy.size.width > proxy.size.height {
                HStack(spacing: 16) {
                    TimerLandspaceView(time: manager.time, color: ui.colors)
                    VStack(spacing: 32) {
                        buttons
                    }
                    .animation(.easeIn, value: manager.isStarted)
                }
            } else {
                VStack(spacing: 16) {
                    TimerPortraitView(time: manager.time, color: ui.colors)
                    HStack(spacing: 32) {
                        buttons
                    }
                }
            }
        }
        .padding()
        .onChange(of: manager.time.seconds) { _ in
            AppManager.shared.playTimer()
        }
    }

    @ViewBuilder var buttons: some View {
        if manager.isPaused {
            stopButton
            resumeButton
        } else if manager.isStarted {
            stopButton
            pauseButton
        } else {
            startButton
        }
    }

    var stopButton: some View {
        NeumorphicButton(action: manager.stop) {
            Image(systemName: "stop")
        }
    }

    var startButton: some View {
        NeumorphicButton(action: {
            withAnimation {
                isTabHidden = true
            }
            manager.start()
        }) {
            Image(systemName: "play")
        }
    }

    var pauseButton: some View {
        NeumorphicButton(action: manager.pause) {
            Image(systemName: "pause")
        }
    }

    var resumeButton: some View {
        NeumorphicButton(action: manager.resume) {
            Image(systemName: "play")
        }
    }
}

#Preview {
    TimerView(isTabHidden: Binding<Bool>.constant(true))
        .background(UIManager.shared.colors.background)
}

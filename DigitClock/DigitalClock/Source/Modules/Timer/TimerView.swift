//
//  TimerView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/17.
//

import ClockShare
import Combine
import DigitalClockShare
import SwiftUI

struct TimerView: View {
    @Binding var isTabHidden: Bool
    @StateObject var manager = TimerManager.shared
    @EnvironmentObject var ui: UIManager

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 16) {
                if proxy.size.width > proxy.size.height {
                    TimerLandspaceView(time: manager.time, color: ui.colors)
                } else {
                    TimerPortraitView(time: manager.time, color: ui.colors)
                }
                HStack(spacing: 64) {
                    buttons
                }
                .height(ui.bottomHeight)
                .font(.system(.title, design: .rounded), weight: .ultraLight)
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
        Button(action: manager.stop) {
            Image(systemName: "stop")
        }
    }

    var startButton: some View {
        Button(action: {
            withAnimation {
                isTabHidden = true
            }
            manager.start()
        }) {
            Image(systemName: "play")
        }
    }

    var pauseButton: some View {
        Button(action: manager.pause) {
            Image(systemName: "pause")
        }
    }

    var resumeButton: some View {
        Button(action: manager.resume) {
            Image(systemName: "play")
        }
    }
}

#Preview {
    TimerView(isTabHidden: Binding<Bool>.constant(true))
        .background(UIManager.shared.colors.background)
}

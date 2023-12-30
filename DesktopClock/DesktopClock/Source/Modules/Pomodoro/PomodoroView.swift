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
                    PomodoroLandspaceView(time: PomodoroManager.shared.time)
                    button
                }
            } else {
                VStack(spacing: 16) {
                    PomodoroPortraitView(time: PomodoroManager.shared.time)
                    button
                }
            }
        }
        .padding()
    }

    @ViewBuilder var button: some View {
        if manager.state != .none {
            stopButton
                .transition(.movingParts.iris(
                    blurRadius: 50
                ))
        } else {
            startButton
                .transition(.movingParts.iris(
                    blurRadius: 50
                ))
        }
    }

    var stopButton: some View {
        HoldOnNeumorphicButton(color: ui.color, action: manager.stop) {
            Image(systemName: "stop")
        }
    }

    var startButton: some View {
        NeumorphicButton(action: manager.startFocus) {
            Image(systemName: "play")
        }
    }
}

#Preview {
    PomodoroView()
        .background(UIManager.shared.color.background)
}

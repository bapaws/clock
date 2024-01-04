//
//  ClockView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/14.
//

import ClockShare
import Combine
import SwiftUI
import SwiftUIX

struct ClockView: View {
    @StateObject var manager: ClockManager = .shared
    @EnvironmentObject var ui: UIManager

    var body: some View {
        GeometryReader { proxy in
            if proxy.size.width > proxy.size.height {
                HStack(spacing: 0) {
                    // 让时钟与计时器大小相同，占位使用
                    // (按钮大小(54) + 空格(16)) ÷ 2 = 35
                    let width = (neumorphicButtonSize.width + 16) / 2
                    Color.clear
                        .frame(width: width, height: width)
                    VStack {
                        ClockLandspaceView(color: ui.colors)
                            .environmentObject(manager)
                    }

                    Color.clear
                        .frame(width: width, height: width)
                }
            } else {
                VStack(spacing: 16) {
                    ClockPortraitView(color: ui.colors)
                        .environmentObject(manager)
                    Color.clear
                        .frame(neumorphicButtonSize)
                }
            }
        }
        .padding()
        .onChange(of: manager.time.seconds) { _ in
            AppManager.shared.playClock()
        }
    }
}

#Preview {
    ClockView()
        .background(UIManager.shared.colors.background)
}

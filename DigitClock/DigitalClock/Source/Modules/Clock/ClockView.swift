//
//  ClockView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/14.
//

import ClockShare
import Combine
import DigitalClockShare
import SwiftDate
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
                    let width = (UIManager.homeButtonSize.width + 16) / 2
                    Color.clear
                        .frame(width: width, height: width)
                    VStack {
                        ClockLandspaceView(color: ui.colors)
                            .environmentObject(manager)
                        date
                    }
                    Color.clear
                        .frame(width: width, height: width)
                }
            } else {
                VStack(spacing: 16) {
                    ClockPortraitView(color: ui.colors)
                        .environmentObject(manager)
                    date
                }
            }
        }
        .padding()
        .onChange(of: manager.time.seconds) { _ in
            AppManager.shared.playClock()
        }
    }

    var date: some View {
        HStack(spacing: 16) {
            Text(manager.time.date.formatted(date: .complete, time: .omitted))
            if manager.timeFormat == .h12 {
                Text(manager.time.meridiem.rawValue)
            }
        }
        .font(.system(.title, design: .rounded), weight: .ultraLight)
        .height(ui.bottomHeight)
    }
}

#Preview {
    ClockView()
        .background(UIManager.shared.colors.background)
}

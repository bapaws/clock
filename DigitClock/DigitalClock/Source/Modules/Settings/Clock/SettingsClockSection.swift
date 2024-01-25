//
//  SettingsClockSection.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import SwiftUI

struct SettingsClockSection: View {
    @Binding var isTimeFormatPresented: Bool

    @EnvironmentObject var clock: ClockManager

    @State var isShowed: Bool = ClockManager.shared.secondStyle != .none

    var body: some View {
        timeFormatView
        .padding(.horizontal)
        SettingsToggleCell(title: R.string.localizable.showSecond(), isOn: $isShowed)
            .onChange(of: isShowed) { isShowed in
                withAnimation {
                    clock.secondStyle = isShowed ? .small : .none
                }
            }
            .padding(.horizontal)
    }

    var timeFormatView: some View {
        HStack(spacing: 2) {
            Text(R.string.localizable.timeFormat())
            Spacer()
            Picker("Page", selection: $clock.timeFormat.animation()) {
                ForEach(TimeFormat.allCases, id: \.self) {
                    Text(LocalizedStringKey(stringLiteral: "\($0)"))
                        .tag($0)
                        .contentShape(Rectangle())
                }
            }
            .contentShape(Rectangle())
            .pickerStyle(.segmented)
            .frame(width: 108)
        }
        .padding(horizontal: .regular, vertical: .small)
        .height(cellHeight)
    }
}

#Preview {
    SettingsClockSection(
        isTimeFormatPresented: Binding<Bool>.constant(false)
    )
    .environmentObject(ClockManager.shared)
}

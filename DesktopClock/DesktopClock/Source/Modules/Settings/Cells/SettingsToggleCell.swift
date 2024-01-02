//
//  SettingsToggleCell.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import SwiftUI

let cellHeight: CGFloat = 64

struct SettingsToggleCell: View {
    var title: String
    var isPro: Bool = false
    @Binding var isOn: Bool

    @EnvironmentObject var ui: UIManager
    
    var body: some View {
        HStack(spacing: 2) {
            Text(title)
            if isPro {
                Image(systemName: "crown")
                    .font(.subheadline)
                    .foregroundColor(ui.colors.secondary)
            }
            Spacer()
            Toggle(title, isOn: $isOn)
                .softSettingsSwitchToggleStyle(tint: ui.colors.secondary, labelsHidden: true)
                .frame(width: 64, height: 32)
        }
        .padding(horizontal: .regular, vertical: .small)
        .height(cellHeight)
    }
}

#Preview {
    VStack {
        SettingsToggleCell(title: "Title", isOn: Binding<Bool>.constant(true))
        SettingsToggleCell(title: "Title", isOn: Binding<Bool>.constant(false))
    }
}

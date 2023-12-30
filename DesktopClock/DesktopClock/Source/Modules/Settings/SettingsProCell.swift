//
//  SettingsProCell.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/26.
//

import SwiftUI
import SwiftUIX

struct SettingsProCell: View {
    let action: () -> Void

    @EnvironmentObject var ui: UIManager

    var body: some View {
        Button(action: action) {
            Text("Pro")
                .frame(.greedy)
                .height(SettingsCell.height * 2)
        }
        .softButtonStyle(RoundedRectangle(cornerRadius: 16), mainColor: ui.color.background, textColor: ui.color.secondaryLabel, darkShadowColor: ui.color.darkShadow, lightShadowColor: ui.color.lightShadow)
        .padding(.horizontal)
        .padding(.horizontal, .small)
        .padding(.vertical)
    }
}

#Preview {
    SettingsProCell(action: {})
        .environmentObject(UIManager.shared)
}

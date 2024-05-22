//
//  SettingsToggleCell.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import HoursShare
import SwiftUI

let cellHeight: CGFloat = 64

struct SettingsToggleCell: View {
    var title: String
    var isNew: Bool = false
    var isPro: Bool = false
    @Binding var isOn: Bool

    @EnvironmentObject var ui: UIManager
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title)
            if isNew {
                SettingsNewTagView()
            }
            if isPro {
                Image(systemName: "crown")
                    .font(.subheadline)
                    .foregroundColor(ui.colors.secondary)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .frame(width: 64, height: 32)
        }
        .font(.body)
        .padding(horizontal: .regular, vertical: .small)
        .height(cellHeight)
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }
}

#Preview {
    VStack {
        SettingsToggleCell(title: "Title", isOn: Binding<Bool>.constant(true))
        SettingsToggleCell(title: "Title", isOn: Binding<Bool>.constant(false))
    }
}

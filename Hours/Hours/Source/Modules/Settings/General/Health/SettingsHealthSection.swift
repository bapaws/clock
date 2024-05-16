//
//  SettingsHealthSection.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/16.
//

import HoursShare
import SwiftUI

struct SettingsHealthSection: View {
    @State private var isHealthPresented: Bool = false

    @EnvironmentObject private var ui: UIManager

    var body: some View {
        SettingsSection(title: R.string.localizable.health()) {
            SettingsNavigateCell(title: R.string.localizable.health()) {
                isHealthPresented = true
            }
        }
        .background(ui.background)
        .sheet(isPresented: $isHealthPresented) {
            SettingsHealthView()
        }
    }
}

#Preview {
    SettingsHealthSection()
}

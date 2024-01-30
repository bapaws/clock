//
//  SettingsSection.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/25.
//

import ClockShare
import DeskClockShare
import SwiftUI
import SwiftUIX

struct SettingsSection<Cell: View, ID: Hashable>: View {
    let title: String
    var itemCount: Int?
    var scrollToID: ID?
    var maxScollItemCount: Int = 4

    @ViewBuilder var content: () -> Cell

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .padding(horizontal: .regular, vertical: .extraSmall)

            if let itemCount = itemCount, itemCount > maxScollItemCount {
                ScrollViewReader { reader in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0, content: content)
                            .onAppear {
                                guard let id = scrollToID else { return }
                                reader.scrollTo(id, anchor: .center)
                            }
                    }
                    .frame(minHeight: 0, maxHeight: CGFloat(maxScollItemCount) * cellHeight, alignment: .center)
                    .background {
                        RoundedRectangle(cornerRadius: 16.0)
                            .fill(Color.Neumorphic.main)
                            .softOuterShadow()
                    }
                }
            } else {
                content()
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical)
        .padding(.horizontal)
        .foregroundColor(Color.Neumorphic.secondary)
        .background(Color.Neumorphic.main)
    }
}

extension SettingsSection where ID == Int {
    init(title: String, @ViewBuilder content: @escaping () -> Cell) {
        self.title = title
        self.content = content
    }
}

extension SettingsSection {
    init(title: String, itemCount: Int?, scrollToID: ID?, @ViewBuilder content: @escaping () -> Cell) {
        self.title = title
        self.content = content
        self.itemCount = itemCount
        self.scrollToID = scrollToID
    }
}

#Preview {
    SettingsSection(title: R.string.localizable.appearance()) {
        SettingsToggleCell(title: "Title", isOn: Binding<Bool>.constant(true))
        SettingsToggleCell(title: "Title", isOn: Binding<Bool>.constant(false))
        SettingsCheckCell(title: "Title", isPro: true, isChecked: false, action: {})
        SettingsCheckCell(title: "Title", isPro: true, isChecked: true, action: {})
        SettingsNavigateCell(title: "Title", value: nil, isPro: true, action: {})
        SettingsNavigateCell(title: "Title", value: "value", isPro: false, action: {})
    }
    .environmentObject(UIManager.shared)
}

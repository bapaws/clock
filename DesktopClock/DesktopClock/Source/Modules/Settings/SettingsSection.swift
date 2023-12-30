//
//  SettingsSection.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/25.
//

import SwiftUI
import SwiftUIX

struct SettingsSection: View {
    let title: String
    let items: [SettingsItem]

    var maxScollItemCount: Int = 4

    @EnvironmentObject var ui: UIManager

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .padding(horizontal: .regular, vertical: .extraSmall)

            ZStack {
                let height = CGFloat(min(items.count, maxScollItemCount)) * SettingsCell.height
                RoundedRectangle(cornerRadius: 16.0)
                    .fill(ui.color.background)
                    .softOuterShadow(darkShadow: ui.color.darkShadow, lightShadow: ui.color.lightShadow)
                    .height(height)

                let stack = VStack(spacing: 0) {
                    // 这里会根据 id 进行刷新，如果不设置默认本身
                    // Settings 页面中，item 本身不变就导致不刷新
                    ForEach(items) { SettingsCell(item: $0).id($0.id) }
                }
                if items.count > maxScollItemCount {
                    ScrollViewReader { reader in
                        ScrollView(showsIndicators: false) {
                            stack.onAppear {
                                guard let first = items.first(where: { item in
                                    if case .check(_, let bool) = item.type, bool {
                                        return true
                                    } else {
                                        return false
                                    }
                                }) else { return }
                                reader.scrollTo(first.id, anchor: .center)
                            }
                        }
                        .height(height)
                    }
                } else {
                    stack
                }
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical)
        .padding(.horizontal)
        .padding(.horizontal, .small)
        .foregroundColor(ui.color.secondaryLabel)
        .background(ui.color.background)
    }
}

#Preview {
    SettingsSection(title: R.string.localizable.appearance(), items: [SettingsItem(type: .popup("标题", "Value"), action: {})])
        .environmentObject(UIManager.shared)
}

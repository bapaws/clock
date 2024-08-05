//
//  EventsHomeEmptyView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/31.
//

import SwiftUI

struct EventsHomeEmptyView: View {
    var newCategory: (() -> Void)?
    var importDefault: (() -> Void)?
    var importFromCalendar: (() -> Void)?

    var body: some View {
        VStack {
            Menu {
                menuContent
            } label: {
                Image(asset: Asset.empty)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }

            HStack(spacing: 16) {
                Button {
                    newCategory?()
                } label: {
                    Label(L10n.newCategory, systemImage: "folder.badge.plus")
                        .frame(width: 160, height: 44, alignment: .center)
                }
                .overlay {
                    Capsule()
                        .stroke(Color.systemGray4, lineWidth: 1)
                }
                .tint(ui.primary)

                Menu {
                    menuContent
                } label: {
                    Label(L10n.import, systemImage: "calendar.badge.plus")
                        .foregroundStyle(.white)
                        .frame(width: 160, height: 44, alignment: .center)
                        .background(ui.primary.opacity(0.9))
                        .cornerRadius(32)
                }
            }

            Spacer()
        }
        .padding(.large)
        .padding(.top, .large)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(ui.background)
    }

    @ViewBuilder var menuContent: some View {
        Button {
            importDefault?()
        } label: {
            Label(L10n.importDefault, systemImage: "plus")
        }

        Button {
            importFromCalendar?()
        } label: {
            Label(L10n.importFromCalendar, systemImage: "calendar.badge.plus")
        }
    }
}

#Preview {
    EventsHomeEmptyView()
}

//
//  SettingsAppIconView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import HoursShare
import SwiftUI
import SwiftUIX

struct SettingsAppIconView: View {
    @EnvironmentObject var ui: UIManager

    @Environment(\.dismiss) var dismiss

    let appIcons = [.lightClassic, AppIconType.darkClassic]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(appIcons, id: \.self) { icon in
                        Button {
                            ui.appIcon = icon
                            dismiss()
                        } label: {
                            HStack {
                                if let image = UIImage(named: icon.imageName) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 42, height: 42)
                                        .cornerRadius(8, style: .continuous)
                                }
                                Text(icon.value)
                                if icon.isPro {
                                    Image(systemName: "crown")
                                        .font(.title3)
                                }
                            }
                            .font(.body)
                        }
                        .buttonStyle(CheckButtonStyle(checked: ui.appIcon == icon))
                        .font(.body)
                        .padding(horizontal: .regular, vertical: .small)
                        .height(cellHeight)
                        .background(ui.secondaryBackground)
                        .cornerRadius(16)
                    }
                }
                .padding()
            }
            .background(ui.background)
            .navigationTitle(R.string.localizable.appIcon())
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.subheadline)
            }))
        }
    }
}

#Preview {
    SettingsAppIconView()
        .environmentObject(UIManager.shared)
}

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
    @Binding var isPresented: Bool
    @EnvironmentObject var ui: UIManager

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach([AppIconType.darkClassic, .lightClassic], id: \.self) { icon in
                        Button {
                            ui.appIcon = icon
                            isPresented = false
                        } label: {
                            HStack {
                                if let image = UIImage(named: icon.imageName) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 72, height: 72)
                                        .cornerRadius(16, style: .continuous)
                                        .shadow(.drop(color: .gray, radius: 5))
                                }
                                Text(icon.value)
                                    .font(.title3)
                                    .padding(.leading, .regular)
                                if icon.isPro {
                                    Image(systemName: "crown")
                                        .font(.title3)
                                }
                                Spacer()
                                Image(systemName: ui.appIcon == icon ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                            }
                            .font(.body)
                        }
                    }
                    .padding(.vertical, .regular)
                    .padding(.horizontal, .large)
                }
            }
            .navigationTitle(R.string.localizable.appIcon())
            .navigationBarItems(leading: Button(action: {
                isPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .font(.subheadline)
            }))
        }
    }
}

#Preview {
    SettingsAppIconView(isPresented: Binding<Bool>.constant(true))
        .environmentObject(UIManager.shared)
}

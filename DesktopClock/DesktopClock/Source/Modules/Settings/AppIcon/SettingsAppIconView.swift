//
//  SettingsAppIconView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import Neumorphic
import SwiftUI
import SwiftUIX

struct SettingsAppIconView: View {
    @Binding var isPresented: Bool
    @State var isPaywallPresented: Bool = false
    @EnvironmentObject var ui: UIManager

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(AppIconType.allCases, id: \.self) { icon in
                        Button {
                            if icon.isPro, !ProManager.default.isPro {
                                isPaywallPresented = true
                            } else {
                                ui.appIcon = icon
                            }
                        } label: {
                            HStack {
                                if let image = UIImage(named: icon.imageName) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 72, height: 72)
                                        .cornerRadius(16, style: .continuous)
                                        .softOuterShadow()
                                }
                                Text(icon.value)
                                    .font(.title3)
                                    .padding(.leading, .regular)
                                    .foregroundColor(Color.Neumorphic.secondary)
                                if icon.isPro {
                                    Image(systemName: "crown")
                                        .font(.title3)
                                        .foregroundColor(ui.colors.secondary)
                                }
                                Spacer()
                                Image(systemName: ui.appIcon == icon ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                            }
                            .foregroundColor(ui.appIcon == icon ? ui.colors.secondary : Color.Neumorphic.secondary)
                            .font(.body)
                        }
                    }
                    .padding(.vertical, .regular)
                    .padding(.horizontal, .large)
                }
            }
            .background(Color.Neumorphic.main)
            .navigationTitle(R.string.localizable.appIcon())
            .navigationBarItems(leading: Button(action: {
                isPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .font(.subheadline)
                    .foregroundColor(Color.Neumorphic.secondary)
            }))
        }
        .sheet(isPresented: $isPaywallPresented) {
            PaywallView(isPresented: $isPaywallPresented)
        }
    }
}

#Preview {
    SettingsAppIconView(isPresented: Binding<Bool>.constant(true))
        .environmentObject(UIManager.shared)
}

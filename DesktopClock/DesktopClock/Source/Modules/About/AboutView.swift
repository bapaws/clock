//
//  AboutView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/28.
//

import Neumorphic
import SwiftUI
import SwiftUIX

struct AboutView: View {
    @Binding var isPresented: Bool

    @State var showSafari = false
    @State var urlString = "https://duckduckgo.com"

    var body: some View {
        NavigationView {
            VStack {
//                Spacer()
                Color.clear
                    .height(64)
                Button {} label: {
                    Image(R.image.launchImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: 25))

                Color.clear
                    .height(32)
                let infoDictionary = Bundle.main.infoDictionary
                if let displayName = infoDictionary?["CFBundleDisplayName"] as? String {
                    Text(displayName)
                } else {
                    Text(R.string.localizable.appName())
                }
                if let majorVersion = infoDictionary?["CFBundleShortVersionString"] as? String,
                   let minorVersion = infoDictionary?["CFBundleVersion"] as? String
                {
                    Text("Version. \(majorVersion) (\(minorVersion))")
                        .font(.footnote)
                        .foregroundColor(.secondaryLabel)
                }
                let year = Calendar.current.component(.year, from: Date())
                Text("Copyright © 2021-\(year) Bapaws. All rights reserved.")
                    .font(.caption)
                    .foregroundColor(.quaternaryLabel)
                Spacer()
                HStack {
                    Button {
                        urlString = "https://privacy.bapaws.com/desktopclock/terms.html"
                        showSafari = true
                    } label: {
                        Text(R.string.localizable.terms())
                            .font(.caption)
                            .foregroundColor(.quaternaryLabel)
                    }
                    Text(R.string.localizable.and())
                        .font(.caption)
                        .foregroundColor(.quaternaryLabel)
                    Button {
                        urlString = "https://privacy.bapaws.com/desktopclock/privacy.html"
                        showSafari = true
                    } label: {
                        Text(R.string.localizable.privacy())
                            .font(.caption)
                            .foregroundColor(.quaternaryLabel)
                    }
                }
            }
            .padding()
            .frame(.greedy)
            .background(Color.Neumorphic.main)
            .navigationTitle(R.string.localizable.about())
            .navigationBarItems(leading: Button(action: {
                isPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .font(.subheadline)
                    .foregroundColor(Color.Neumorphic.secondary)
            }))
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: URL(string: self.urlString)!)
        }
    }
}

#Preview {
    AboutView(isPresented: Binding<Bool>.constant(true))
        .background(Color.Neumorphic.main)
}

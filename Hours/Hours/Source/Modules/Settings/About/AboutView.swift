//
//  AboutView.swift
//  Hours
//
//  Created by 张敏超 on 2023/12/28.
//

import SwiftUI
import SwiftUIX

struct AboutView: View {
    @State var urlString: String?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Color.clear
                    .height(64)
                Image(asset: Asset.launchImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Color.clear
                    .height(32)
                let infoDictionary = Bundle.main.infoDictionary
                if let displayName = infoDictionary?["CFBundleDisplayName"] as? String {
                    Text(displayName)
                } else {
                    Text(L10n.appName)
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
                        urlString = "https://bapaws.super.site/隐私政策/用户协议"
                    } label: {
                        Text(L10n.terms)
                            .font(.caption)
                            .foregroundColor(.tertiaryLabel)
                    }
                    Text(L10n.and)
                        .font(.caption)
                        .foregroundColor(.tertiaryLabel)
                    Button {
                        urlString = "https://bapaws.super.site/隐私政策/隐私协议"
                    } label: {
                        Text(L10n.privacy)
                            .font(.caption)
                            .foregroundColor(.tertiaryLabel)
                    }
                }
            }
            .padding()
            .frame(.greedy)
            .background(ui.background)
            .navigationTitle(L10n.about)
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.subheadline)
            }))
        }
        .sheet(item: $urlString) {
            SafariView(url: URL(string: $0)!)
        }
    }
}

#Preview {
    AboutView()
}

//
//  FeedbackView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/7.
//

import ClockShare
import MessageUI
import SwiftUI

struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isEmailPresented: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    SettingsNavigateCell(title: R.string.localizable.sendEmail(), value: "dev@bapaws.com") {
                        if MFMailComposeViewController.canSendMail() {
                            isEmailPresented.toggle()
                        } else if let url = emailURL, UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        } else {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = "dev@bapaws.com"
                            Toast.show(R.string.localizable.emailCopied())
                        }
                    }

                    if let url = URL(string: "twitter://user?screen_name=minchaozhang"), UIApplication.shared.canOpenURL(url) {
                        SettingsNavigateCell(title: R.string.localizable.x()) {
                            UIApplication.shared.open(url)
                        }
                    }

                    if let url = URL(string: "weixin://"), UIApplication.shared.canOpenURL(url) {
                        SettingsNavigateCell(title: R.string.localizable.weChat()) {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = "wxid_yuo1hb20v39u22"

                            Toast.show(R.string.localizable.weChatCopied())
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }

                    if let url = URL(string: "xhsdiscover://user/6481492100000000120342c4"), UIApplication.shared.canOpenURL(url) {
                        SettingsNavigateCell(title: R.string.localizable.redBook()) {
                            UIApplication.shared.open(url)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .background(ui.background)
            .navigationTitle(R.string.localizable.feedback())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .sheet(isPresented: $isEmailPresented) {
                let infoDictionary = Bundle.main.infoDictionary
                let majorVersion = infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                let systemName = UIDevice.current.systemName // 设备名称
                let systemVersion = UIDevice.current.systemVersion // ios版本
                let model = UIDevice.current.model // 设备型号
                let localizedModel = UIDevice.current.localizedModel

                MailView(recipients: ["dev@bapaws.com"], subject: "\(R.string.localizable.appName)-\(R.string.localizable.feedback())", messageBody: R.string.localizable.emailMessageBody(systemName, systemVersion, localizedModel, majorVersion), isHTML: true, result: $result)
            }
        }
        .background(ui.background)
    }

    var emailURL: URL? {
        let subject = "\(R.string.localizable.appName)-\(R.string.localizable.feedback())"

        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion = infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let systemName = UIDevice.current.systemName // 设备名称
        let systemVersion = UIDevice.current.systemVersion // ios版本
        let model = UIDevice.current.model // 设备型号
        let localizedModel = UIDevice.current.localizedModel
        let body = R.string.localizable.emailMessageBody(systemName, systemVersion, localizedModel, majorVersion)

        guard
            let subject = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let body = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {
            print("Error: Can't encode subject or body.")
            return nil
        }

        let urlString = "mailto:dev@bapaws.com?subject=\(subject)&body=\(body)"
        return URL(string: urlString)
    }
}

#Preview {
    FeedbackView()
}

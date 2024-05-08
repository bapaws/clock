//
//  SwiftUIView.swift
//
//
//  Created by 张敏超 on 2024/5/7.
//

import MessageUI
import SwiftUI
import UIKit

public struct MailView: UIViewControllerRepresentable {
    public let recipients: [String]
    public let subject: String?
    public let messageBody: String?
    public let isHTML: Bool
    @Binding public var result: Result<MFMailComposeResult, Error>?

    public init(recipients: [String], subject: String? = nil, messageBody: String? = nil, isHTML: Bool = true, result: Binding<Result<MFMailComposeResult, Error>?>) {
        self.recipients = recipients
        self.subject = subject
        self.messageBody = messageBody
        self.isHTML = isHTML
        self._result = result
    }

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var result: Result<MFMailComposeResult, Error>?

        @Environment(\.dismiss) private var dismiss

        init(result: Binding<Result<MFMailComposeResult, Error>?>) {
            _result = result
        }

        public func mailComposeController(_ controller: MFMailComposeViewController,
                                          didFinishWith result: MFMailComposeResult,
                                          error: Error?)
        {
            defer { dismiss() }

            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(result: $result)
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(recipients)
        if let subject = subject {
            vc.setSubject(subject)
        }
        if let messageBody = messageBody {
            vc.setMessageBody(messageBody, isHTML: isHTML)
        }
        return vc
    }

    public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                       context: UIViewControllerRepresentableContext<MailView>) {}
}

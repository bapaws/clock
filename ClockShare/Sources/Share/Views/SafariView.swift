//
//  SafariView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/28.
//

import SafariServices
import SwiftUI
import UIKit

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}

#Preview {
    SafariView(url: URL(string: "https://www.baidu.com")!)
}

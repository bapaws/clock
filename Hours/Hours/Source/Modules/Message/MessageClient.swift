//
//  MessageClient.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/11.
//

import ClockShare
import Dependencies
import Foundation

struct MessageItem: Equatable, Identifiable {
    var id: Int
    var emoji: String
    var title: String
    var languageCode: String = "en"
    var content: String?
    var contentURL: String?
    var openURL: String?
    var openTitle: String?
}

struct MessageClient {
    var fetch: () async throws -> [MessageItem]

    func notShowAgain(message: MessageItem) {
        Storage.default.notShowAgain(message: message)
    }

    func willShow(message: MessageItem, at date: Date?) {
        Storage.default.willShow(message: message, at: date)
    }
}

extension MessageClient: DependencyKey {
    static let liveValue = Self(
        fetch: {
            var languageCode: String
            if #available(iOS 16, *) {
                languageCode = NSLocale.current.language.languageCode?.identifier ?? "zh"
            } else {
                languageCode = NSLocale.current.languageCode ?? "zh"
            }

            let messages = [
                MessageItem(
                    id: 0,
                    emoji: "✉️",
                    title: "App Store 五🌟好评，可获得包月会员～",
                    languageCode: "zh",
                    content: "",
                    contentURL: "https://bapaws.super.site/活动消息/免费领取月费会员",
                    openURL: "https://apps.apple.com/app/id6479001202?action=write-review"
                ),
                MessageItem(
                    id: 1,
                    emoji: "🧧",
                    title: "小红书发布推荐笔记，可获得包年会员～",
                    languageCode: "zh",
                    contentURL: "",
                    openURL: "xhsdiscover://user/6481492100000000120342c4"
                ),
            ]
            .filter {
                guard $0.languageCode == languageCode else { return false }

                if Storage.default.messageIsNotShowAgain($0) { return false }

                guard let date = Storage.default.messageWillShowAt($0) else { return true }
                return date.timeIntervalSince1970 > Date.now.timeIntervalSince1970
            }

            return messages
        }
    )
}

extension DependencyValues {
    var messageClient: MessageClient {
        get { self[MessageClient.self] }
        set { self[MessageClient.self] = newValue }
    }
}

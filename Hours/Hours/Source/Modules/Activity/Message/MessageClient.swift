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
    var illustration: String?
    var isNotPro: Bool = true
    var startAt: Date?
    var endAt: Date?
}

struct MessageClient {
    var fetch: () async throws -> [MessageItem]
    var fetchAll: () async throws -> [MessageItem]
    var fetchWillStart: () async throws -> [MessageItem]
    var fetchExpired: () async throws -> [MessageItem]

    func notShowAgain(message: MessageItem) {
        Storage.default.notShowAgain(message: message)
    }

    func willShow(message: MessageItem, at date: Date?) {
        Storage.default.willShow(message: message, at: date)
    }
}

extension MessageClient: DependencyKey {
    private static var items: [MessageItem] {
        [
            MessageItem(
                id: 0,
                emoji: "🎁",
                title: "快来领取包月会员",
                languageCode: "zh",
                content: """
                **App Store 五🌟好评，可免费领取包月会员～**\n
                1. 点击「[https://apps.apple.com/cn/app/id6479001202](https://apps.apple.com/cn/app/id6479001202)」，打开 App Store。\n
                2. 给「**时间记录**」一个五🌟好评，也可以同时写下使用体验。
                """,
                contentURL: "https://bapaws.super.site/活动消息/免费领取月费会员",
                openURL: "https://apps.apple.com/app/id6479001202?action=write-review",
                openTitle: "去写评论",
                illustration: "Success"
            ),
            MessageItem(
                id: 1,
                emoji: "🧧",
                title: "发小红书，免费领取一整年的会员",
                languageCode: "zh",
                content: """
                在 [小红书](xhsdiscover://user/6481492100000000120342c4) 发布「**时间记录**」相关的笔记，可以免费领取一整年的会员。\n
                您可以发布各种关于「**时间记录**」的笔记，包括但不限于以下的内容：
                  • 使用心得
                  • 喜欢或经常使用的功能
                  • 一天的记录
                  • 等等…

                快去试试吧🎈，点击「[xhsdiscover://post/](xhsdiscover://post/)」打开小红书。
                """,
                contentURL: "https://bapaws.super.site/活动消息/发小红书赢年会员",
                openURL: "xhsdiscover://user/6481492100000000120342c4",
                openTitle: "打开小红书",
                illustration: "Send",
                endAt: Date(year: 2024, month: 4, day: 7, hour: 20, minute: 0)
            ),
        ]
    }

    private static func isValidVersion() async -> Bool {
        let infoDictionary = Bundle.main.infoDictionary
        guard let majorVersion = infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }

        #if DEBUG
        return true
        #else
        let appStoreVersion = await AppManager.shared.fetchAppStoreVersion()
        return majorVersion != appStoreVersion
        #endif
    }

    private static var languageCode: String {
        if #available(iOS 16, *) {
            return NSLocale.current.language.languageCode?.identifier ?? "zh"
        } else {
            return NSLocale.current.languageCode ?? "zh"
        }
    }

    static let liveValue = Self(
        fetch: {
            guard await isValidVersion() else { return [] }

            let languageCode: String = MessageClient.languageCode
            let isPro = ProManager.default.isPro
            let now = Date.now
            return items
                .filter {
                    guard $0.languageCode == languageCode, $0.isNotPro != isPro else { return false }

                    if let startAt = $0.startAt, now < startAt { return false }
                    if let endAt = $0.endAt, now > endAt { return false }

                    if Storage.default.messageIsNotShowAgain($0) { return false }

                    guard let date = Storage.default.messageWillShowAt($0) else { return true }
                    return date.timeIntervalSince1970 < now.timeIntervalSince1970
                }
        },
        fetchAll: {
            guard await isValidVersion() else { return [] }

            let languageCode: String = MessageClient.languageCode
            let isPro = ProManager.default.isPro
            let now = Date.now
            return items.filter {
                guard $0.languageCode == languageCode, $0.isNotPro != isPro else { return false }

                if let startAt = $0.startAt, now < startAt { return false }
                if let endAt = $0.endAt, now > endAt { return false }

                return true
            }
        },
        fetchWillStart: {
            guard await isValidVersion() else { return [] }

            let languageCode: String = MessageClient.languageCode
            let isPro = ProManager.default.isPro
            let now = Date.now
            return items.filter {
                guard $0.languageCode == languageCode, $0.isNotPro != isPro else { return false }

                if let startAt = $0.startAt, now > startAt { return true }

                return false
            }
        },
        fetchExpired: {
            guard await isValidVersion() else { return [] }

            let languageCode: String = MessageClient.languageCode
            let isPro = ProManager.default.isPro
            let now = Date.now
            return items.filter {
                guard $0.languageCode == languageCode, $0.isNotPro != isPro else { return false }

                if let endAt = $0.endAt, now > endAt { return true }

                return false
            }
        }
    )
}

extension DependencyValues {
    var messageClient: MessageClient {
        get { self[MessageClient.self] }
        set { self[MessageClient.self] = newValue }
    }
}

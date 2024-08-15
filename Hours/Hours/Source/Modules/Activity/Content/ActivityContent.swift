//
//  ActivityContent.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/13.
//

import ComposableArchitecture
import SwiftDate
import SwiftUI
import SwiftUIX

@Reducer
struct ActivityContent {
    @ObservableState
    struct State: Equatable {
        var item: MessageItem

        var isReceiveWayOpened: Bool = false
        var isDetailPresented: Bool = false
        var detailURL: URL?
        var contentURL: URL? {
            if let contentURL = item.contentURL, let url = URL(string: contentURL) {
                return url
            }
            return nil
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case reminderLater
        case detail
        case notInterested
        case open

        case openReceiveWay
    }

    @Dependency(\.messageClient) var messageClient
    @Dependency(\.date.now) var now
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case .detail:
                state.isDetailPresented.toggle()
                return .none

            case .open:
                if let openURL = state.item.openURL, let url = URL(string: openURL) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
                return .run { send in
                    await send(.notInterested)
                }

            case .notInterested:
                return .run { [item = state.item] _ in
                    messageClient.notShowAgain(message: item)
                    await dismiss()
                }

            case .reminderLater:
                return .run { [item = state.item] _ in
                    #if DEBUG
                    messageClient.willShow(
                        message: item,
                        at: now.addingTimeInterval(20)
                    )
                    #else
                    messageClient.willShow(
                        message: item,
                        at: now.addingTimeInterval(24 * 3600)
                    )
                    #endif
                    await dismiss()
                }

            case .openReceiveWay:
                state.isReceiveWayOpened.toggle()
                return .none

            default:
                return .none
            }
        }
    }
}

struct ActivityContentView: View {
    @Perception.Bindable var store: StoreOf<ActivityContent>

    var body: some View {
        NavigationStack {
            WithPerceptionTracking {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(store.item.emoji)
                            .font(.system(size: 72))
                        Text(store.item.title)
                            .font(.title)
                        if let content = store.item.content {
                            Text(LocalizedStringKey(content))
                        }

                        if let illustration = store.item.illustration {
                            Image(illustration)
                                .resizable()
                        }

                        if let receiving = store.item.receiveWay {
                            Button {
                                store.send(.openReceiveWay, animation: .default)
                            } label: {
                                HStack {
                                    Text(L10n.receiveWay)
                                    Image(systemName: "triangle.fill")
                                        .font(.caption2)
                                        .rotationEffect(store.isReceiveWayOpened ? .degrees(180) : .degrees(90))
                                }
                                .foregroundStyle(ui.primary)
                            }
                            .buttonStyle(.plain)

                            if store.isReceiveWayOpened {
                                Text(LocalizedStringKey(receiving))
                            }
                        }

                        if store.contentURL != nil {
                            Button {
                                store.send(.detail)
                            } label: {
                                Text(L10n.activityDetail)
                                    .foregroundStyle(ui.primary)
                            }
                            .buttonStyle(.plain)
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .scrollIndicators(.never)
                .safeAreaInset(edge: .top) {
                    HStack {
                        Spacer()
                        Button {
                            store.send(.reminderLater)
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(ui.label)
                                .padding()
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    HStack(spacing: 16) {
                        Button {
                            store.send(.notInterested)
                        } label: {
                            Text(L10n.notInterested)
                                .padding(.vertical, .small)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(ui.primary)
                        .cornerRadius(16)

                        Button {
                            store.send(.open)
                        } label: {
                            Text(store.item.openTitle ?? L10n.ok)
                                .padding(.vertical, .small)
                                .frame(maxWidth: .infinity)
                        }
                        .tint(ui.primary)
                        .foregroundStyle(Color.white)
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(16)
                    }
                    .padding()
                    .background(ui.background)
                }
                .background(ui.background)

                .sheet(isPresented: $store.isDetailPresented) {
                    SafariView(url: store.contentURL!)
                }
            }
        }
    }
}

#Preview {
    ActivityContentView(
        store: .init(
            initialState: .init(
                item: MessageItem(
                    id: 0,
                    emoji: "🎁",
                    title: "快来领取包月会员",
                    languageCode: "zh",
                    content: """
                    **App Store 五🌟好评，可免费领取包月会员～**\n
                    1. 点击「[**时间记录**](https://apps.apple.com/app/id6479001202?action=write-review)」，打开 App Store。\n
                    2. 给「**时间记录**」一个五🌟好评，也可以同时写下使用体验。
                    """,
                    contentURL: "https://bapaws.super.site/活动消息/免费领取月费会员",
                    openURL: "https://apps.apple.com/app/id6479001202?action=write-review",
                    openTitle: "去写评论",
                    illustration: "Success",
                    receiveWay: """
                    🔴小红书\n
                      1. 打开小红书，🔍搜索开发者小红书账户：[6481492100000000120342c4](xhsdiscover://user/6481492100000000120342c4)。点击❤️关注。
                      2. 点击私信页面，将「**你的评分与评论**」页面的截图发送给账户。
                      3. 我们将在 24 小时内，私信会员兑换码。\n
                    🟢微信\n
                      1. 添加「**时间记录**」客服账户：[**Bapaws**](weixin://)。
                      2. 将「**你的评分与评论**」页面的截图发送给客服账户。
                      3. 将在 24 小时内，发送会员兑换码。\n
                    **👉由于会员码的限制，只能在 App Store 兑换一次。**\n
                    """
                )
            ),
            reducer: { ActivityContent() }
        )
    )
}

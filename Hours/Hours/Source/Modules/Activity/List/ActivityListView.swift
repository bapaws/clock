//
//  ActivityListView.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/14.
//

import ComposableArchitecture
import HoursShare
import SwiftUI
import SwiftUIX

@Reducer
struct ActivityListFeature {
    @ObservableState
    struct State: Equatable {
        var items: IdentifiedArrayOf<MessageItem> = []
        var willStartItems: IdentifiedArrayOf<MessageItem> = []
        var expiredItems: IdentifiedArrayOf<MessageItem> = []

        var isDetailPresented: Bool = false
        var detailURL: URL?

        @Presents var content: ActivityContent.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case appendMessage(MessageItem)
        case appendWillStartMessage(MessageItem)
        case appendExpiredMessage(MessageItem)

        case content(PresentationAction<ActivityContent.Action>)

        case close

        case onDetailTapped(MessageItem)
        case onTapped(MessageItem)
    }

    @Dependency(\.continuousClock) private var clock
    @Dependency(\.messageClient) private var messageClient

    @Dependency(\.dismiss) private var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let items = try await messageClient.fetchAll()
                    for item in items {
                        await send(.appendMessage(item), animation: .default)
                        try await clock.sleep(for: .milliseconds(200))
                    }
                }

            case .appendMessage(let item):
                state.items.append(item)
                return .none

            case .appendWillStartMessage(let item):
                state.willStartItems.append(item)
                return .none

            case .appendExpiredMessage(let item):
                state.expiredItems.append(item)
                return .none

            case .close:
                return .run { _ in await dismiss() }

            case .onDetailTapped(let item):
                if let contentURL = item.contentURL, let url = URL(string: contentURL) {
                    state.detailURL = url
                    state.isDetailPresented.toggle()
                }
                return .none

            case .onTapped(let item):
                state.content = .init(item: item)
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$content, action: \.content) {
            ActivityContent()
        }
    }
}

struct ActivityListView: View {
    @Perception.Bindable var store: StoreOf<ActivityListFeature>
    var body: some View {
        NavigationStack {
            WithPerceptionTracking {
                List(store.items) { item in
                    HStack {
                        Text(item.emoji)
                            .font(.system(size: 32))
                            .frame(width: 48, height: 48, alignment: .center)
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.system(.body, weight: .bold))
                                .foregroundStyle(ui.label)
                            if let content = item.content {
                                Text(LocalizedStringKey(content))
                                    .lineLimit(1)
                                    .font(.subheadline)
                                    .foregroundStyle(ui.secondaryLabel)
                            }
                        }

                        Spacer()

                        if let contentURL = item.contentURL, let _ = URL(string: contentURL) {
                            Button {
                                store.send(.onDetailTapped(item))
                            } label: {
                                Text(L10n.activityDetail)
                                    .foregroundStyle(ui.primary)
                                    .font(.footnote)
                                    .padding(.vertical)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    .background(ui.secondaryBackground)
                    .cornerRadius(16)
                    .listRowSeparator(.hidden)
                    .listRowBackground(ui.background)
                    .onTapGesture {
                        store.send(.onTapped(item))
                    }
                }
                .emptyStyle(isEmpty: store.items.isEmpty)
                .listStyle(.plain)
                .background(ui.background)
                .navigationTitle(L10n.activities)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            store.send(.close)
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .onAppearOnce {
                    store.send(.onAppear)
                }
                .sheet(item: $store.scope(state: \.content, action: \.content)) {
                    ActivityContentView(store: $0)
                }
                .fullScreenCover(isPresented: $store.isDetailPresented) {
                    SafariView(url: store.detailURL!)
                }
            }
        }
    }
}

#Preview {
    ActivityListView(
        store: .init(
            initialState: .init(),
            reducer: { ActivityListFeature() }
        )
    )
}

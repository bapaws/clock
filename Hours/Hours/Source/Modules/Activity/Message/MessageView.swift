//
//  MessageView.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/11.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct Message {
    @ObservableState
    struct State: Equatable {
        var items: IdentifiedArrayOf<MessageItem> = []
        var index: Int = 0

        @Presents var activity: ActivityContent.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case messageDidLoad([MessageItem])

        case timer
        case timerTicked
        case cancelTimer

        case notShowAgain(MessageItem)
        case close(MessageItem)
        case onTapped(MessageItem)

        case activity(PresentationAction<ActivityContent.Action>)
    }

    private enum CancelID { case timer }
    @Dependency(\.continuousClock) var clock
    @Dependency(\.date.now) var now

    @Dependency(\.messageClient) var messageClient

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let items = try await messageClient.fetch()
                    await send(.messageDidLoad(items), animation: .default)

                    if items.count <= 1 { return }
                    for await _ in self.clock.timer(interval: .seconds(5)) {
                        await send(.timerTicked, animation: .interpolatingSpring(stiffness: 3000, damping: 40))
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)

            case .messageDidLoad(let items):
                state.index = 0
                state.items = .init(uniqueElements: items)
                return .none

            case .timerTicked:
                if state.index == state.items.count - 1 {
                    state.index = 0
                } else {
                    state.index += 1
                }
                return .none

            case .notShowAgain(let item):
                state.items.remove(id: item.id)
                return .run { send in
                    messageClient.notShowAgain(message: item)

                    await send(.cancelTimer)
                }

            case .close(let item):
                if state.index == state.items.count - 1 {
                    state.index = 0
                } else {
                    state.index += 1
                }
                state.items.remove(at: state.index)
                return .run { send in
                    #if DEBUG
                    messageClient.willShow(
                        message: item,
                        at: now.addingTimeInterval(20)
                    )
                    #else
                    messageClient.willShow(
                        message: item,
                        at: now.addingTimeInterval(3 * 24 * 3600)
                    )
                    #endif

                    await send(.cancelTimer)
                    await send(.onAppear)
                }

            case .cancelTimer:
                return .cancel(id: CancelID.timer)

            case .onTapped(let item):
                state.activity = .init(item: item)
                return .none

            case .activity(.presented(.reminderLater)),
                 .activity(.presented(.notInterested)):
                return .run { send in
                    await send(.cancelTimer)
                    await send(.onAppear)
                }

            default:
                return .none
            }
        }
        .ifLet(\.$activity, action: \.activity) {
            ActivityContent()
        }
    }
}

struct MessageView: View {
    @Perception.Bindable var store: StoreOf<Message>
    var body: some View {
        WithPerceptionTracking {
            if !store.items.isEmpty {
                let item = store.items[store.index]
                MessageItemView(item: item) {
                    store.send(.close(item), animation: .default)
                } onTapped: {
                    store.send(.onTapped(item))
                }
                .fullScreenCover(item: $store.scope(state: \.activity, action: \.activity)) {
                    ActivityContentView(store: $0)
                }
            }
        }
    }
}

#Preview {
    MessageView(
        store: .init(initialState: .init(), reducer: { Message() })
    )
}

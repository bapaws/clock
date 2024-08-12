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
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case messageDidLoad([MessageItem])

        case timer
        case timerTicked

        case notShowAgain(MessageItem)
        case close
    }

    private enum CancelID { case timer }
    @Dependency(\.continuousClock) var clock

    @Dependency(\.messageClient) var messageClient

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let items = try await messageClient.fetch()
                    await send(.messageDidLoad(items))

                    guard !items.isEmpty else { return }

                    for await _ in self.clock.timer(interval: .seconds(5)) {
                        await send(.timerTicked, animation: .interpolatingSpring(stiffness: 3000, damping: 40))
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)

            case .messageDidLoad(let items):
                state.items.append(contentsOf: items)
                return .none

            case .timerTicked:
                state.index += 1
                return .none

            case .notShowAgain(let item):
                state.items.remove(id: item.id)
                return .run { _ in
                    messageClient.notShowAgain(message: item)
                }

            case .close:
                if state.index == state.items.count - 1 {
                    state.index = 0
                } else {
                    state.items.remove(at: state.index)
                }
                return .none

            default:
                return .none
            }
        }
    }
}

struct MessageView: View {
    let store: StoreOf<Message>
    var body: some View {
        WithPerceptionTracking {
            MessageItemView(item: store.items[store.index]) {
                store.send(.close)
            }
        }
    }
}

#Preview {
    MessageView(
        store: .init(initialState: .init(), reducer: { Message() })
    )
}

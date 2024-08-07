//
//  MessageItemView.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/7.
//

import ComposableArchitecture
import HoursShare
import SwiftUI

@Reducer
struct MessageItem {
    @ObservableState
    struct State: Equatable {
        var emoji: String
        var title: String
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            default:
                return .none
            }
        }
    }
}

struct MessageItemView: View {
    var body: some View {
        HStack {
            Text("✉️")
            Text("App Store 五🌟好评，可获得包月会员～")
                .font(.footnote)
                .foregroundStyle(ui.label)
            Spacer()
            Button {} label: {
                Image(systemName: "xmark")
                    .font(.footnote)
                    .foregroundStyle(Color.placeholderText)
            }
        }
        .padding(.small)
        .background(ui.secondaryBackground)
        .cornerRadius(16)
        .padding()
    }
}

#Preview {
    MessageItemView()
        .background(Color.systemGray6)
}

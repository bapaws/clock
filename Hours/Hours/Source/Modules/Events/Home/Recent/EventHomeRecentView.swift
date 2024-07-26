//
//  EventHomeRecentView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/5.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import SwiftUI
import SwiftUIX

struct EventHomeRecentView: View {
    let store: StoreOf<EventHomeRecentFeature>

    let dimension: CGFloat = 78

    var body: some View {
        WithPerceptionTracking {
            if !store.events.isEmpty {
                Section {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(store.events) { event in
                                VStack {
                                    Spacer()
                                    if let emoji = event.emoji {
                                        Text(emoji)
                                        Spacer()
                                    }
                                    Text(event.name)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.5)
                                        .font(.subheadline)
                                        .foregroundStyle(event.primary)
                                    Spacer()
                                }
                                .padding(.small)
                                .frame(width: dimension, height: dimension, alignment: .center)
                                .background(event.primaryContainer)
                                .cornerRadius(16)
                                .onTapGesture {
                                    store.send(.onEventTapped(event))
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .scrollIndicators(.hidden)
                } header: {
                    HStack {
                        Text(L10n.recent)
                        Spacer()
                    }
                    .font(.footnote)
                    .padding(horizontal: .regular, vertical: .extraSmall)
                    .background(ui.background)
                }
            }
        }
    }
}

#Preview {
    EventHomeRecentView(
        store: StoreOf<EventHomeRecentFeature>(
            initialState: .init(), reducer: { EventHomeRecentFeature() }
        )
    )
}

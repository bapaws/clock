//
//  WidgetView.swift
//  Hours
//
//  Created by 张敏超 on 2024/12/10.
//

import ComposableArchitecture
import HoursShare
import SwiftUI

struct SettingsWidgetTabView: View {
    @Perception.Bindable var store: StoreOf<SettingsWidgetTabFeature>

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                VStack {
                    StatisticsPageBar(SettingsWidgetTabFeature.State.PageIndex.allCases, selection: $store.pageIndex.animation()) {
                        if store.pageIndex == $0 {
                            Text("\($0)")
                                .foregroundStyle(ui.label)
                                .font(.title3)
                        } else {
                            Text("\($0)")
                                .foregroundStyle(ui.secondaryLabel)
                                .font(.title3)
                        }
                    }

                    TabView(selection: $store.pageIndex.animation()) {
                        SettingsWidgetView(store: store.scope(state: \.medium, action: \.medium))
                            .tag(SettingsWidgetTabFeature.State.PageIndex.medium)

                        SettingsWidgetView(store: store.scope(state: \.large, action: \.large))
                            .tag(SettingsWidgetTabFeature.State.PageIndex.large)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                .background(ui.background)
                .navigationTitle(L10n.widget)
                .navigationBarItems(trailing: Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.subheadline)
                }))
            }
        }
    }
}

#Preview {
    SettingsWidgetTabView(store: .init(initialState: .init(), reducer: { SettingsWidgetTabFeature() }))
}

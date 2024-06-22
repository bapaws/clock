//
//  SwiftUIView.swift
//
//
//  Created by 张敏超 on 2024/6/16.
//

import ComposableArchitecture
import SwiftUI

public struct InfinitePageView<C, T>: View where C: View, T: Hashable {
    @Binding public var selection: T

    public let backward: (T) -> T
    public let forward: (T) -> T

    @ViewBuilder public let view: (T) -> C

    @State private var currentTab: Int = 0

    public init(selection: Binding<T>, backward: @escaping (T) -> T, forward: @escaping (T) -> T, view: @escaping (T) -> C) {
        self._selection = selection
        self.backward = backward
        self.forward = forward
        self.view = view
    }

    public var body: some View {
        WithPerceptionTracking {
            let previousIndex = backward(selection)
            let nextIndex = forward(selection)
            TabView(selection: $currentTab) {
                view(previousIndex)
                    .tag(-1)

                view(selection)
                    .onDisappear {
                        if currentTab != 0 {
                            selection = currentTab < 0 ? previousIndex : nextIndex
                            currentTab = 0
                        }
                    }
                    .tag(0)

                view(nextIndex)
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .disabled(currentTab != 0)
        }
    }
}

#Preview {
    InfinitePageView(selection: .constant(0)) {
        $0 - 1
    } forward: {
        $0 + 1
    } view: {
        Text("\($0)")
    }
}

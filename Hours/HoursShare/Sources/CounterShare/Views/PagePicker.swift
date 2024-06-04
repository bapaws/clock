//
//  PagePicker.swift
//
//
//  Created by 张敏超 on 2024/6/2.
//

import SwiftUI

public struct PagePicker<Data: Identifiable & Equatable, Content: View>: View {
    public let sources: [Data]
    @Binding public var selection: Data?

    private let itemBuilder: (Data) -> Content

    public init(
        _ sources: [Data],
        selection: Binding<Data?>,
        @ViewBuilder itemBuilder: @escaping (Data) -> Content
    ) {
        self.sources = sources
        self._selection = selection
        self.itemBuilder = itemBuilder
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(sources) { item in
                ZStack {
                    itemBuilder(item)
                    if selection == item {
                        Circle()
                            .foregroundStyle(ui.primary)
                            .offset(y: 10)
                    }
                }
            }
        }
    }
}

// #Preview {
//    PagePicker()
// }

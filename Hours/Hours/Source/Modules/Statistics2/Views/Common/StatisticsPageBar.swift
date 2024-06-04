//
//  StatisticsPageBar.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/2.
//

import SwiftUI

struct StatisticsPageBar<Data: Identifiable & Equatable, Content: View>: View {
    public let sources: [Data]
    @Binding public var selection: Data

    private let itemBuilder: (Data) -> Content

    init(
        _ sources: [Data],
        selection: Binding<Data>,
        @ViewBuilder itemBuilder: @escaping (Data) -> Content
    ) {
        self.sources = sources
        self._selection = selection
        self.itemBuilder = itemBuilder
    }

    var body: some View {
        let itemHeight = CGFloat(44)
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                let itemWidth = proxy.size.width / CGFloat(sources.count)
                HStack(spacing: 0) {
                    ForEach(sources) { item in
                        Button {
                            selection = item
                        } label: {
                            itemBuilder(item)
                                .frame(width: itemWidth, height: itemHeight - 2, alignment: .center)
                        }
                    }
                }
                .frame(width: proxy.size.width, alignment: .center)

                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundStyle(ui.primary)
                    .offset(x: itemWidth / 2 + itemWidth * CGFloat(sources.firstIndex(of: selection) ?? 0) - 3, y: -6)

                Divider()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: itemHeight, maxHeight: itemHeight, alignment: .center)
    }
}

#Preview {
    StatisticsPageBar(
        Statistics.State.PageIndex.allCases,
        selection: .constant(.day)
    ) {
        Text("\($0)")
    }
}

//
//  ListRow.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/12.
//

import HoursShare
import SwiftUI

private struct ListRowPlain: ViewModifier {
    var separator: Visibility
    var background: Color
    var insets: EdgeInsets?

    func body(content: Content) -> some View {
        content
            .listRowSeparator(separator)
            .listRowBackground(background)
            .listRowInsets(insets)
    }
}

public extension View {
    func listRowPlain(
        separator: Visibility = .hidden,
        background: Color? = nil,
        insets: EdgeInsets? = nil
    ) -> some View {
        modifier(
            ListRowPlain(
                separator: separator,
                background: ui.background,
                insets: .init(top: 4, leading: 16, bottom: 4, trailing: 16)
            )
        )
    }
}

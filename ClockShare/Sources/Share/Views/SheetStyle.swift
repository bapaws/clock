//
//  SwiftUIView.swift
//
//
//  Created by 张敏超 on 2024/5/11.
//

import SwiftUI

@available(iOS 16.0, *)
struct SheetStyleModifier: ViewModifier {
    public func body(content: Content) -> some View {
        let view = content
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .labelsHidden()
        if #available(iOS 16.4, *) {
            return view
                .presentationCornerRadius(32)
                .presentationContentInteraction(.scrolls)
        } else {
            return view
        }
    }
}

public extension View {
    @available(iOS 16.0, *)
    func sheetStyle() -> some View {
        modifier(SheetStyleModifier())
    }
}

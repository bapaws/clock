//
//  File.swift
//
//
//  Created by 张敏超 on 2024/1/10.
//

import SwiftUI
import SwiftUIX
import WidgetKit

public extension WidgetConfiguration {
    func disableContentMarginsIfNeeded() -> some WidgetConfiguration {
        if #available(iOS 17.0, *) {
            return self.contentMarginsDisabled()
        } else {
            return self
        }
    }
}

public extension View {
    func containerBackground<S>(_ style: S) -> some View where S: ShapeStyle {
        if #available(iOS 17.0, *) {
            return self.containerBackground(style, for: .widget)
        } else {
            return self.background(style)
        }
    }

    @ViewBuilder func ifLet<T, Content: View>(_ object: T?, transform: (Self, T) -> Content) -> some View {
        if let obj = object {
            transform(self, obj)
        } else {
            self
        }
    }
}

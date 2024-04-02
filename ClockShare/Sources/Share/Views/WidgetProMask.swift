//
//  WidgetProMask.swift
//
//
//  Created by 张敏超 on 2024/4/2.
//

import SwiftUI

struct WidgetProMask: ViewModifier {
    var isPreview: Bool = false
    var font: Font?
    var tapAction: () -> Void
    var isPro: Bool { ProManager.default.isPro }

    @ViewBuilder func body(content: Content) -> some View {
        if isPro || isPreview {
            content
        } else {
            ZStack {
                content
                    .blur(radius: 5)

                VStack(spacing: 24) {
                    Image(systemName: "crown")
                        .font(font ?? .system(size: 32))
                        .foregroundStyle(Color.systemOrange)
                }
            }
            .widgetURL(URL(string: "widget://pro")!)
        }
    }
}

public extension View {
    func proMask(font: Font? = nil, isPreview: Bool = false) -> some View {
        modifier(WidgetProMask(isPreview: isPreview, tapAction: {}))
    }
}

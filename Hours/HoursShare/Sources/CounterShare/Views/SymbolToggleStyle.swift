//
//  SymbolToggleStyle.swift
//
//
//  Created by 张敏超 on 2024/3/5.
//

import Foundation
import SwiftUI
import SwiftUIX

public struct SymbolToggleStyle: ToggleStyle {
    public var onSystemName: String
    public var onActiveColor: Color = .black
    public var onFillColor: Color = .green
    public var offSystemName: String
    public var offActiveColor: Color = .black
    public var offFillColor: Color = .systemGray5

    public init(
        onSystemName: String,
        onActiveColor: Color = .label,
        onFillColor: Color = .green,
        offSystemName: String,
        offActiveColor: Color = .primary,
        offFillColor: Color = .systemGray5
    ) {
        self.onSystemName = onSystemName
        self.onActiveColor = onActiveColor
        self.onFillColor = onFillColor
        self.offSystemName = offSystemName
        self.offActiveColor = offActiveColor
        self.offFillColor = offFillColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(configuration.isOn ? onFillColor : offFillColor)
                .overlay {
                    Circle()
                        .fill(.white)
                        .padding(3)
                        .overlay {
                            Image(systemName: configuration.isOn ? onSystemName : offSystemName)
                                .foregroundColor(.black)
                                .rotationEffect(.degrees(configuration.isOn ? 0 : -360))
                        }
                        .offset(x: configuration.isOn ? 10 : -10)
                }
                .frame(width: 50, height: 32)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}

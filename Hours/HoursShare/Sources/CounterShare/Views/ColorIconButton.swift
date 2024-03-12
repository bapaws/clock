//
//  ColorIconButton.swift
//
//
//  Created by 张敏超 on 2024/3/5.
//

import SwiftUI
import SwiftUIX

public struct ColorIconButton: View {
    var action: () -> Void
    @Binding var color: Color

    public init(color: Binding<Color>, action: @escaping () -> Void) {
        _color = color
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 30)
                .fill(color)
                .frame(width: 23, height: 23)
                .shadow(.drop(color: Color.gray, radius: 3))
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white, lineWidth: 3)
                )
                .frame(width: 26, height: 26)
        }
    }
}

#Preview {
    ColorIconButton(color: Binding<Color>.constant(.red)) {
        print("color")
    }
}

//
//  ColorIconView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/30.
//

import HoursShare
import SwiftUI

struct ColorIconView: View {
    let hex: HexEntity
    let radius: CGFloat

    private let padding: CGFloat

    init(hex: HexEntity, radius: CGFloat = 21) {
        self.hex = hex
        self.radius = radius
        self.padding = floor(radius / 4)
//        self.padding = 1
    }

    var body: some View {
//        Circle()
//            .fill(
//                LinearGradient(colors: [
//                    hex.lightPrimaryContainer,
//                    hex.lightPrimaryContainer,
//                    hex.darkPrimaryContainer,
//                    hex.darkPrimaryContainer
//                ], startPoint: .leading, endPoint: .trailing)
//            )
//            .frame(width: radius * 2, height: radius * 2, alignment: .center)
        HStack(spacing: 0) {
            Rectangle()
                .fill(hex.lightPrimaryContainer)
            Rectangle()
                .fill(hex.darkPrimaryContainer)
        }
        .cornerRadius(radius - padding)
        .padding(padding)
//        .background {
//            HStack(spacing: 0) {
//                Rectangle()
//                    .fill(hex.lightPrimaryContainer)
//                Rectangle()
//                    .fill(hex.darkPrimaryContainer)
//            }
//            .cornerRadius(radius)
//        }
        .frame(width: radius * 2, height: radius * 2, alignment: .center)
    }
}

#Preview {
    ColorIconView(hex: .random)
}

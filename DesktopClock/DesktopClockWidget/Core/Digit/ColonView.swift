//
//  ColonView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/9.
//

import ClockShare
import SwiftUI

struct ColonView: View {
    var colorType: ColorType

    var body: some View {
        VStack {
            Image("\(colorType.rawValue)ColonInner")
                .resizable()
                .scaledToFit()
            Image("\(colorType.rawValue)ColonInner")
                .resizable()
                .scaledToFit()
        }
//        VStack {
//            Image("\(colorType.rawValue)ColonOuter")
//                .resizable()
//                .scaledToFit()
//            Image("\(colorType.rawValue)ColonOuter")
//                .resizable()
//                .scaledToFit()
//        }
    }
}

#Preview {
    ColonView(colorType: .classic)
}

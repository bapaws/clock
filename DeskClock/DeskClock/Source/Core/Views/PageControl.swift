//
//  PageControl.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/17.
//

import ClockShare
import DeskClockShare
import Neumorphic
import SwiftUI
import SwiftUIX

struct PageControl: View {
    @Binding var index: Int
    @Binding var offsetX: CGFloat

    @EnvironmentObject var ui: UIManager

    var body: some View {
        GeometryReader { proxy in
            let itemWidth = proxy.size.width / 3
            let itemHeight = proxy.size.height
            ZStack(alignment: .leading) {
                Button(action: {
                    print("action")
                }, label: {
                    Color.clear
                        .frame(width: itemWidth, height: itemHeight)
                })
                .softButtonStyle(Capsule(), padding: 0, mainColor: ui.colors.background, textColor: ui.colors.primary, darkShadowColor: ui.colors.darkShadow, lightShadowColor: ui.colors.lightShadow)
                .offset(x: itemWidth * CGFloat(index) + offsetX * itemWidth)

                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation {
                            index = 0
                        }
                    }, label: {
                        Text(UIManager.shared.icon.pomodoro)
                            .minimumScaleFactor(0.1)
                    })
                    .frame(width: itemWidth, height: itemHeight)
                    Button(action: {
                        withAnimation {
                            index = 1
                        }
                    }, label: {
                        Text(UIManager.shared.icon.clock)
                            .minimumScaleFactor(0.1)
                    })
                    .frame(width: itemWidth, height: itemHeight)
                    Button(action: {
                        withAnimation {
                            index = 2
                        }
                    }, label: {
                        Text(UIManager.shared.icon.timer)
                            .minimumScaleFactor(0.1)
                    })
                    .frame(width: itemWidth, height: itemHeight)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .font(UIManager.shared.icon.font)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    VStack {
        PageControl(index: Binding<Int>.constant(0), offsetX: Binding<CGFloat>.constant(0))
            .background(UIManager.shared.colors.background)
            .frame(width: 240, height: 54)
        PageControl(index: Binding<Int>.constant(1), offsetX: Binding<CGFloat>.constant(0))
            .background(UIManager.shared.colors.background)
            .frame(width: 240, height: 54)
        PageControl(index: Binding<Int>.constant(1), offsetX: Binding<CGFloat>.constant(0))
            .background(UIManager.shared.colors.background)
            .frame(width: 240, height: 54)
    }
    .environmentObject(UIManager.shared)
}

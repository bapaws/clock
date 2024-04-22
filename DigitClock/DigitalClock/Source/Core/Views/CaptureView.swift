//
//  CaptureView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import DigitalClockShare
import SwiftUI
import SwiftUIX

struct CaptureView: View {
    let colors = Colors.classic(mode: .light)
//    let colors = Colors.pink(mode: .dark)
//    let colors = Colors.orange(mode: .dark)
//    let colors = Colors.purple(mode: .dark)

    var body: some View {
        logo
    }

    // MARK: Logo

    @ViewBuilder var logo: some View {
        let padding: CGFloat = 120
        let width: CGFloat = 1024
        let digitWidth: CGFloat = width - padding * 2
        Text("25")
            .monospacedDigit()
            .padding(.all, padding)
            .frame(width: width, height: width)
//            .foregroundColor(colors.primary)
//            .background(colors.background)
            .foregroundColor(colors.background)
            .background(colors.primary)
            .font(.system(size: digitWidth * 0.8, design: .rounded), weight: .ultraLight)
            .capture(size: CGSize(width: width, height: width), ignoreSafeArea: true) {
                guard let image = $0 else { return }
                print(image)
            }
    }
}

#Preview {
    CaptureView()
}

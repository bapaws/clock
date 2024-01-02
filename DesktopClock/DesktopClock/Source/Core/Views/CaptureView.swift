//
//  CaptureView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import SwiftUI
import SwiftUIX

struct CaptureView: View {
//    let colors = Colors(
//        scheme: .light,
//        lightThemePrimary: Color(red: 0.482, green: 0.502, blue: 0.549),
//        lightThemeSecondary: Color.systemTeal,
//        lightThemeBackground: Color(red: 0.925, green: 0.941, blue: 0.953),
//        lightThemeDarkShadow: Color(red: 0.820, green: 0.851, blue: 0.902),
//        lightThemeLightShadow: Color(red: 1.000, green: 1.000, blue: 1.000),
//        darkThemePrimary: Color(red: 0.910, green: 0.910, blue: 0.910),
//        darkThemeSecondary: Color.systemTeal,
//        darkThemeBackground: Color(red: 0.188, green: 0.192, blue: 0.208),
//        darkThemeDarkShadow: Color(red: 0.137, green: 0.137, blue: 0.137),
//        darkThemeLightShadow: Color(red: 0.243, green: 0.247, blue: 0.275)
//    )
    let colors = Colors(scheme: .light, light: Color(hexadecimal6: 0xFF96B6), dark: Color(hexadecimal6: 0xFF96B6))
//    let colors = Colors(scheme: .light, light: Color(hexadecimal6: 0xf58653), dark: Color(hexadecimal6: 0xf58653))
//    let colors = Colors(scheme: .light, light: Color(hexadecimal6: 0x9a4cf4), dark: Color(hexadecimal6: 0x907Dac))

    var body: some View {
        let padding: CGFloat = 176
        let width: CGFloat = 1024
        let digitWidth: CGFloat = width - padding * 2
        NeumorphicDigit(tens: 0, ones: 0, color: colors, cornerRadius: 176, spread: 0.35, radius: 16)
            .padding(.all, padding)
            .frame(width: width, height: width)
            .foregroundColor(colors.primary)
            .background(colors.background)
            .font(.system(size: digitWidth * 0.6, design: .rounded), weight: .bold)
            .capture(size: CGSize(width: width, height: width), ignoreSafeArea: true) {
                guard let image = $0 else { return }
                print(image)
            }
    }
}

#Preview {
    CaptureView()
}

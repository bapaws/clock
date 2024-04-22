//
//  CaptureView.swift
//  DeskClock
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import DeskClockShare
import Neumorphic
import SwiftUI
import SwiftUIX

struct CaptureView: View {
//    let colors = Colors.classic(mode: .dark)
//    let colors = Colors.pink(mode: .dark)
//    let colors = Colors.orange(mode: .dark)
    let colors = Colors.purple(mode: .dark)

    var body: some View {
        // Navigate Press
//        logo
        inner
        colon
//        button
    }

    // MARK: Logo

    @ViewBuilder var logo: some View {
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

    // MARK: Inner

    @ViewBuilder var inner: some View {
        Color.clear
            .frame(width: 50, height: 50)
            .softInnerShadow(RoundedRectangle(cornerRadius: 8), darkShadow: colors.darkShadow, lightShadow: colors.lightShadow, spread: 0.5, radius: 5)
            .offset(x: 0, y: -34)
            .capture(size: CGSize(width: 50, height: 50), ignoreSafeArea: true) {
                guard let image = $0 else { return }
                print(image)
            }
    }

    // MARK: Widget Colon

    @ViewBuilder var colon: some View {
        Circle()
            .fill(colors.background)
            .frame(width: 32, height: 32)
            .offset(x: 0, y: -34)
            .softOuterShadow(darkShadow: colors.darkShadow, lightShadow: colors.lightShadow, offset: 3, radius: 3)
            .capture(size: CGSize(width: 50, height: 50), ignoreSafeArea: true) {
                guard let image = $0 else { return }
                print(image)
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }

        Color.clear
            .frame(width: 32, height: 32)
            .softInnerShadow(Circle(), darkShadow: colors.darkShadow, lightShadow: colors.lightShadow, spread: 0.5, radius: 5)
            .offset(x: 0, y: -43)
            .capture(size: CGSize(width: 32, height: 32), ignoreSafeArea: true) {
                guard let image = $0 else { return }
                print(image)
            }
    }

    // MARK: Button

    @ViewBuilder var button: some View {
        Button(action: {}) {
            Color.clear
                .frame(width: 48, height: 48)
                .offset(x: 0, y: 12)
        }
        .softButtonStyle(RoundedRectangle(cornerRadius: 16.0), mainColor: colors.background, darkShadowColor: colors.darkShadow, lightShadowColor: colors.lightShadow)
        .capture(size: CGSize(width: 72, height: 72), ignoreSafeArea: true) {
            guard let image = $0 else { return }
            print(image)
        }
    }

    // MARK: Navigate

    @ViewBuilder var navigateForward: some View {
        Circle()
            .fill(colors.background)
            .scaleEffect(0.97)
            .softInnerShadow(Circle())
            .overlay {
                Image(systemName: "chevron.forward")
                    .font(.footnote)
            }
            .frame(width: 36, height: 36)
            .foregroundColor(colors.primary)
            .capture(size: CGSize(width: 108, height: 108), ignoreSafeArea: true) {
                guard let image = $0 else { return }
                print(image)
            }

        // Navigate
        Circle()
            .fill(colors.background)
            .scaleEffect(1)
            .softOuterShadow()
            .overlay {
                Image(systemName: "chevron.forward")
                    .font(.footnote)
            }
            .frame(width: 36, height: 36)
            .foregroundColor(colors.primary)
            .capture(size: CGSize(width: 200, height: 200), ignoreSafeArea: true) {
                guard let image = $0 else { return }
                print(image)
            }
    }
}

#Preview {
    CaptureView()
}

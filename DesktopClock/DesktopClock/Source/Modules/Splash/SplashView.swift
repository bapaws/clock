//
//  SplashView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/23.
//

import ClockShare
import Neumorphic
import SwiftUI
import UIKit

struct SplashView: View {
    @Binding var didFinishLoad: Bool

    var body: some View {
        GeometryReader { _ in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("LaunchImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                    Text("Colorful Clock")
                        .font(.system(size: 25, weight: .thin))
                    Spacer()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    didFinishLoad = true
                }
            }
        }
    }
}

#Preview {
    SplashView(didFinishLoad: Binding<Bool>.constant(false))
}

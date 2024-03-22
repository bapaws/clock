//
//  SplashView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/23.
//

import ClockShare
import SwiftUI
import UIKit

struct SplashView: View {
    @Binding var didFinishLoad: Bool

    #if DEBUG
    @State var isLogoPresented = false
    #endif

    var body: some View {
        GeometryReader { _ in
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Image("LaunchImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)
                    Text(R.string.localizable.appName())
                        .foregroundColor(.secondaryLabel)
                        .font(.system(size: 20, weight: .thin))
                    Spacer()
                }
                .height(72)
                .offset(x: -12)
            }
            .padding(.bottom, 16)
            .background(ui.background)
            .onAppear {
                #if DEBUG
                guard !isLogoPresented else { return }
                #endif
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation {
                        didFinishLoad = true
                    }
                }
            }
        }

        #if DEBUG
        .sheet(isPresented: $isLogoPresented) {
                LogoView()
            }
        #endif
    }
}

#Preview {
    SplashView(didFinishLoad: Binding<Bool>.constant(false))
}

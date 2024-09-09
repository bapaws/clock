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
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                Image("LaunchImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                Text(L10n.appName)
                    .foregroundColor(.secondaryLabel)
                    .font(.system(size: 20, weight: .thin))
                Spacer()
            }
            .height(72)
            .offset(x: -12)
        }
        .padding(.bottom, 16)
        .background(ui.background)
    }
}

// #Preview {
//    SplashView(didFinishLoad: Binding<Bool>.constant(false))
// }

//
//  OnboardingAppScreenTimeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/13.
//

import SwiftUI
import SwiftUIX

struct OnboardingAppScreenTimeView: View {
    @State private var isGuidePresented: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .shadow(color: .systemGray4, x: 0, y: 0, blur: 10)

            LinearGradient(colors: [
                Color(hexadecimal6: 0x8480EB),
                Color(hexadecimal6: 0x5756D6)
            ], startPoint: .top, endPoint: .bottom)
                .cornerRadius(15)

            Image(systemName: "hourglass")
                .font(.system(size: 48))
                .foregroundStyle(.white)
        }
        .frame(width: 72, height: 72)

        ui.background.height(48)

        Text(R.string.localizable.appScreenTimeTitle())
            .font(.title)
            .height(36)

        Text(R.string.localizable.appScreenTimeDesc())
            .multilineTextAlignment(.center)
            .foregroundStyle(ui.secondaryLabel)

        Button {
            isGuidePresented.toggle()
        } label: {
            HStack(spacing: 2) {
                Text(R.string.localizable.autoRecordSetupGuide())
                Image(systemName: "chevron.forward")
            }
            .padding(.small)
            .font(.callout)
            .foregroundStyle(Color.systemPink)
        }
        .sheet(isPresented: $isGuidePresented) {
            SafariView(url: URL(string: "https://zytllepnl6.feishu.cn/docx/PFtQdUY04og6rbxvbsHciiHNnZd")!)
        }


        Spacer()
    }
}

#Preview {
    OnboardingAppScreenTimeView()
}

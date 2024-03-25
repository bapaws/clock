//
//  ProMask.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/22.
//

import SwiftUI

struct ProMask: ViewModifier {
    // MARK: Paywall

    @State var isPaywallPresented: Bool = false

    var isPro: Bool { ProManager.default.isPro }

    @ViewBuilder func body(content: Content) -> some View {
        if isPro {
            content
        } else {
            ZStack {
                content
                    .blur(radius: 8)

                VStack(spacing: 24) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 48), weight: .light)
                        .foregroundStyle(Color.systemOrange)
                    Text(R.string.localizable.tryFree())
                        .foregroundStyle(Color.systemOrange)
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.vertical, .small)
                        .background {
                            Capsule()
                                .stroke(Color.systemOrange, lineWidth: 1.0)
                        }
                }
            }

            // MARK: Paywall

            .fullScreenCover(isPresented: $isPaywallPresented) {
                PaywallView()
            }
            .onTapGesture {
                isPaywallPresented = true
            }
        }
    }
}

extension View {
    func proMask() -> some View {
        modifier(ProMask())
    }
}

//
//  WinnerView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/6.
//

import SwiftUI
import SwiftUIX

struct WinnerView: View {
    var onClose: () -> Void
    var onFinish: () -> Void
    var onBreak: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle")
                        .font(.title, weight: .thin)
                        .foregroundStyle(ui.label)
                }
                .frame(width: 36, height: 36)
                .padding()
            }

            VStack {
                Image("Winner")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)

                Text(R.string.localizable.congratulations())
                    .font(.body)
                    .padding(.vertical)

                HStack(spacing: 16) {
                    Button(R.string.localizable.leave()) {
                        onFinish()
                    }
                    .buttonStyle(.plain)
                    .font(.body, weight: .bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .foregroundColor(ui.primary)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ui.primary, lineWidth: 1.0)
                    }
                    .cornerRadius(12)

                    Button(R.string.localizable.startBreak()) {
                        onBreak()
                    }
                    .buttonStyle(.plain)
                    .font(.body, weight: .bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .foregroundColor(.white)
                    .background(ui.primary)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, .large)
            .padding(.bottom, .large)
        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
        .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
        .padding(.horizontal, .large)
    }
}

#Preview {
    WinnerView {} onFinish: {} onBreak: {}
}

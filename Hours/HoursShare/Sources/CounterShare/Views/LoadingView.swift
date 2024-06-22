//
//  LoadingView.swift
//
//
//  Created by 张敏超 on 2024/6/22.
//

import SwiftUI
import SwiftUIX

public struct LoadingView<Content: View>: View {
    @Binding public var isLoading: Bool
    public var content: () -> Content

    public init(isLoading: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isLoading = isLoading
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: .center) {
            self.content()
                .disabled(isLoading)

            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.large)
                    .tint(.systemGray)

                Text(R.string.localizable.loading())
                    .font(.headline)
                    .foregroundStyle(Color.label)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 28)
            .background(.ultraThickMaterial)
            .cornerRadius(20)
            .scaleEffect(isLoading ? CGSize(width: 1, height: 1) : .zero)
            .opacity(isLoading ? 1 : 0)
            .animation(.easeOut(duration: 0.2), value: isLoading)
        }
    }
}

#Preview {
    LoadingView(isLoading: .constant(true)) {
        Color.red
    }
}

//
//  StatisticsSection.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/1.
//

import SwiftUI
import SwiftUIX
import Perception

struct StatisticsSection<Content: View>: View {
    let title: String
    let content: () -> Content

    var body: some View {
        WithPerceptionTracking {
            Section {
                content()
                    .background(ui.secondaryBackground)
                    .cornerRadius(16)
            } header: {
                HStack {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(ui.secondaryLabel)
                    Spacer()
                }
                .padding(horizontal: .regular, vertical: .extraSmall)
                .padding(.top)
                .background(ui.background)
            }
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    StatisticsSection(title: "Title") {
        Text("Hello world!")
    }
}

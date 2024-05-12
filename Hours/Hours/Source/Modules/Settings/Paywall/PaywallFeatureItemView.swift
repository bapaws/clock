//
//  PaywallFeatureItemView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/20.
//

import HoursShare
import SwiftUI
import SwiftUIX

struct PaywallFeatureItemView: View {
    let info: String
    var body: some View {
        HStack {
            Image(systemName: "checkmark")
                .foregroundColor(ui.secondary)
                .font(.body, weight: .black)
            Text(info)
                .font(.subheadline)
            Spacer()
        }
    }
}

#Preview {
    PaywallFeatureItemView(info: "移除应用内广告")
}

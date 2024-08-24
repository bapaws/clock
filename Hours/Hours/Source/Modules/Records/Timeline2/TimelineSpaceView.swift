//
//  TimelineSpaceView.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/24.
//

import SwiftUI

struct TimelineSpaceView: View {
    var body: some View {
        HStack {
            HStack {
                Rectangle()
                    .fill(ui.primary)
                    .frame(width: 1)
            }
            .frame(width: 18)

            Spacer()
                .padding(.vertical, 12)
        }
    }
}

#Preview {
    TimelineSpaceView()
}

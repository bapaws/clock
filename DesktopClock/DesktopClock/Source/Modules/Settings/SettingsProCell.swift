//
//  SettingsProCell.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/26.
//

import SwiftUI
import SwiftUIX

struct SettingsProCell: View {
    let action: () -> Void

    @EnvironmentObject var ui: UIManager

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(R.string.localizable.proMembership())
                        .font(.title2)
                        .foregroundColor(Color.white)
                    Text(R.string.localizable.unlockPro())
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                }
                Spacer()
                Text(R.string.localizable.tryFree())
                    .font(.headline)
                    .foregroundColor(Color.white)
            }
        }
        .softButtonStyle(RoundedRectangle(cornerRadius: 16), mainColor: UIManager.shared.colors.secondary, pressedEffect: .flat)
        .padding(.horizontal)
        .padding(.horizontal, .small)
        .padding(.vertical)
    }
}

#Preview {
    SettingsProCell(action: {})
}

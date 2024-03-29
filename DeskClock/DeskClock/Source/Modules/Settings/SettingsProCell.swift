//
//  SettingsProCell.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/26.
//

import ClockShare
import DeskClockShare
import SwiftUI
import SwiftUIX

struct SettingsProCell: View {
    let action: () -> Void

    @EnvironmentObject var ui: UIManager
    @EnvironmentObject var pro: ProManager

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(pro.purchasedProduct?.localizedTitle ?? R.string.localizable.proMembership())
                        .font(.title2)
                        .foregroundColor(Color.white)
                    let subTitle = pro.isPro ? R.string.localizable.slogan() : R.string.localizable.unlockPro()
                    Text(subTitle)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                }
                Spacer()
                if pro.isPro {
                    Image(systemName: "crown")
                        .font(.title)
                        .foregroundColor(Color.white)
                } else {
                    Text(R.string.localizable.tryFree())
                        .font(.headline)
                        .foregroundColor(Color.white)
                }
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

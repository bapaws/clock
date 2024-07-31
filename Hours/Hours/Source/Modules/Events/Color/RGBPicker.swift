//
//  RGBPicker.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/31.
//

import ComposableArchitecture
import SwiftUI
import HoursShare

struct RGBHexView: View {
    var hex: HexEntity
    var diameter: CGFloat = 48

    var body: some View {
        HStack(spacing: ceil(diameter / 6)) {
            Circle().fill(hex.color)
                .frame(width: diameter, height: diameter)

            Divider()
                .frame(width: 1, height: diameter)

            HStack(spacing: -8) {
                Circle().fill(hex.lightPrimaryContainer)
                    .frame(width: diameter, height: diameter)
                Circle().fill(hex.darkPrimaryContainer)
                    .frame(width: diameter, height: diameter)
                Circle().fill(hex.lightPrimary)
                    .frame(width: diameter, height: diameter)
                Circle().fill(hex.darkPrimary)
                    .frame(width: diameter, height: diameter)
            }
        }
    }
}

struct RGBPicker: View {
    @Perception.Bindable var store: StoreOf<ColorPickFeature>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 16) {
                HStack {
//                    Text(L10n.color)
//                        .font(.title)
//                        .foregroundStyle(ui.primary)
//                        .padding()
                    Spacer()

//                    RGBHexView(hex: store.initialHex, diameter: 18)
                    Button {
                        store.send(.random, animation: .default)
                    } label: {
                        Image(systemName: .dice)
//                        Text("🎲")
                            .padding()
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                RGBHexView(hex: store.hex)

                Spacer()

                HStack(spacing: 16) {
                    Text("R")
                    Slider(value: $store.red) {
                        Text("R")
                    }
                    .tint(.red)
                }
                .padding(.horizontal)
                .padding(.bottom, .small)

                HStack(spacing: 16) {
                    Text("G")
                    Slider(value: $store.green) {
                        Text("G")
                    }
                    .tint(.green)
                }
                .padding(.horizontal)
                .padding(.bottom, .small)

                HStack(spacing: 16) {
                    Text("B")
                    Slider(value: $store.blue) {
                        Text("B")
                    }
                    .tint(.blue)
                }
                .padding(.horizontal)

                Spacer()

                HStack(spacing: 16) {
                    Button {
                        store.send(.cancel)
                    } label: {
                        Text(L10n.cancel)
                            .padding(.vertical, .small)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(ui.primary)
                    .cornerRadius(16)

                    Button {
                        store.send(.save)
                    } label: {
                        Text(L10n.save)
                            .padding(.vertical, .small)
                            .frame(maxWidth: .infinity)
                    }
                    .tint(ui.primary)
                    .foregroundStyle(Color.white)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(16)
                }
            }
            .padding()
            .padding(.bottom, .extraLarge)
            .background(ui.background)
        }
    }
}

#Preview {
    RGBPicker(
        store: .init(
            initialState: .init(hex: .random),
            reducer: { ColorPickFeature() }
        )
    )
}

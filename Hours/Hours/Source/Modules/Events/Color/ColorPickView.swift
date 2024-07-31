//
//  ColorPickView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/30.
//

import ComposableArchitecture
import HoursShare
import SwiftUI
import SwiftUIX

struct ColorPickView: View {
    let store: StoreOf<ColorPickFeature>
    var body: some View {
        WithPerceptionTracking {
            List(store.entities) { entity in
                VStack {
                    HStack {}
                    HStack {
                        Circle().fill(entity.color)
                            .frame(width: 32, height: 32)

                        Divider()
                            .frame(width: 1, height: 32)

                        HStack(spacing: -8) {
                            Circle().fill(entity.lightPrimaryContainer)
                                .frame(width: 32, height: 32)
                            Circle().fill(entity.darkPrimaryContainer)
                                .frame(width: 32, height: 32)
                            Circle().fill(entity.lightPrimary)
                                .frame(width: 32, height: 32)
                            Circle().fill(entity.darkPrimary)
                                .frame(width: 32, height: 32)
                        }
                    }
                }
                .padding(.vertical)
            }

//            ScrollView {
//                LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
//                    ForEach(store.entities) { entity in
//                        ColorIconView(hex: entity, radius: 32)
//                            .onTapGesture {
//                                store.send(.didSelectHex(entity))
//                            }
//                    }
//                }
//                .padding()
//                .padding(.vertical, .large)
//            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    ColorPickView(
        store: .init(
            initialState: .init(hex: .random),
            reducer: { ColorPickFeature() }
        )
    )
}

//
//  ColorPickFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/30.
//

import ComposableArchitecture
import Foundation
import HoursShare
import UIKit

@Reducer
struct ColorPickFeature {
    @ObservableState
    struct State: Equatable {
        var hueCategories: [HexEntity.HueCategory] = []
        var hexEntities: [HexEntity.HueCategory: [HexEntity]] = [:]

        var entities = [HexEntity]()

        var initialHex: HexEntity
        var hex: HexEntity

        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat

//        init(red: CGFloat = .random(in: 0 ... 1), green: CGFloat = .random(in: 0 ... 1), blue: CGFloat = .random(in: 0 ... 1)) {
//            self.red = red
//            self.green = green
//            self.blue = blue
//
//            hex = HexEntity(red: red, green: green, blue: blue)
//        }

        init(hex: HexEntity) {
            self.initialHex = hex
            self.hex = hex
            self.red = hex.red
            self.green = hex.green
            self.blue = hex.blue
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case appendHex(HexEntity.HueCategory, HexEntity)

        case didSelectHex(HexEntity)
        case onHexChanged(HexEntity)

        case random

        case cancel
        case save
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    var entities = [HexEntity]()
                    let categoryCount = 12
                    for category in HexEntity.HueCategory.allCases {
                        let range = category.hueRange
                        let hueDistance = Double(range.upperBound - range.lowerBound) / Double(categoryCount)
                        for index in 0 ..< 12 {
                            let hue = Double(range.upperBound) + Double(index) * hueDistance + Double.random(in: hueDistance / 2 ..< hueDistance)
                            let saturation = Double.random(in: 0 ... 1)
                            let brightness = Double.random(in: 0 ... 1)
                            let color = UIColor(hue: CGFloat(hue) / CGFloat(360), saturation: saturation, brightness: brightness, alpha: 1.0)
                            let entity = HexEntity(rgb: color.argb)
                            entities.append(entity)
                        }
                    }

//                    for index in 0 ..< count {
//                        let hue = Double(index) * (range.upperBound - range.lowerBound) + Double.random(in: range)
//                        let saturation = Double.random(in: 0 ... 1)
//                        let brightness = Double.random(in: 0 ... 1)
//                        let color = UIColor(hue: CGFloat(hue) / CGFloat(count), saturation: saturation, brightness: brightness, alpha: 1.0)
//                        let entity = HexEntity(rgb: color.argb)
//                        entities.append(entity)
//                    }
                    entities = entities.sorted(by: { $0.uiLightPrimaryContainer.hue < $1.uiLightPrimaryContainer.hue })

                    for entity in entities {
                        let hueCategory = HexEntity.HueCategory(color: entity.lightPrimary)
                        await send(.appendHex(hueCategory, entity), animation: .default)

                        try await clock.sleep(for: .milliseconds(20))
                    }
                }

            case .appendHex(let hueCategory, let entity):
                state.entities.append(entity)

//                if !state.hueCategories.contains(where: { $0 == hueCategory }) {
//                    state.hueCategories.append(hueCategory)
//                    state.hueCategories = state.hueCategories.sorted(by: { $0.rawValue < $1.rawValue })
//                }
//                var entities = state.hexEntities[hueCategory] ?? []
//                entities.append(entity)
//                state.hexEntities[hueCategory] = entities.sorted(by: { $0.hue < $1.hue })
                return .none

            case .didSelectHex:
                return .run { _ in await dismiss() }

            case .binding:
                return .run { [state] send in
                    let entity = HexEntity(red: state.red, green: state.green, blue: state.blue)
                    await send(.onHexChanged(entity), animation: .default)
                }

            case .onHexChanged(let entity):
                state.hex = entity
                return .none

            case .random:
                let hex  = HexEntity.random
                state.hex = hex
                state.red = hex.red
                state.green = hex.green
                state.blue = hex.blue
                return .none

            case .cancel:
                return .run { _ in await dismiss() }

            case .save:
                return .run { [hex = state.hex] send in
                    await send(.didSelectHex(hex))
                    await dismiss()
                }

            default:
                return .none
            }
        }
    }
}

//
//  SoundType.swift
//
//
//  Created by 张敏超 on 2023/12/23.
//

import AVFoundation
import ClockShare
import Foundation
import SwiftUI

public extension SoundType {
    var value: String {
        switch self {
        case .tick:
            R.string.localizable.tick()
        case .second:
            R.string.localizable.secondHand()
        case .drip:
            R.string.localizable.drip()
        }
//        switch self {
//        case .card:
//            R.string.localizable.card()
//        case .drip:
//            R.string.localizable.drip()
//        case .muyu:
//            R.string.localizable.muyu()
//        case .pendulum:
//            R.string.localizable.pendulum()
//        case .switch:
//            R.string.localizable.switch()
//        case .tick:
//            R.string.localizable.tick()
//        }
    }
}

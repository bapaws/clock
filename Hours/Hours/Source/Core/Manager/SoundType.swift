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
            L10n.tick
        case .second:
            L10n.secondHand
        case .drip:
            L10n.drip
        }
//        switch self {
//        case .card:
//            L10n.card
//        case .drip:
//            L10n.drip
//        case .muyu:
//            L10n.muyu
//        case .pendulum:
//            L10n.pendulum
//        case .switch:
//            L10n.switch
//        case .tick:
//            L10n.tick
//        }
    }
}

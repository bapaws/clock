//
//  Digit.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/15.
//

import Foundation

public enum Digit: Int, CaseIterable {
    case zero, one, two, three, four, five, six, seven, eight, nine
}

extension Digit: Identifiable {
    public var id: Self {
        self
    }
}

extension Digit {
    public var text: String {
        "\(rawValue)"
    }
}

//
//  File.swift
//
//
//  Created by 张敏超 on 2024/6/1.
//

import Foundation

public struct TimeLength: Codable, Equatable, Hashable {
    public let day: Int
    public let hour: Int
    public let minute: Int
    public let second: Int

    public init(day: Int, hour: Int, minute: Int, second: Int) {
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
    }

    public init(integer: Int) {
        let seconds: Int = .init((Double(integer) / 1000).rounded())
        self.day = seconds / 3600 / 24
        self.hour = seconds / 3600 % 24
        self.minute = seconds / 60 % 60
        self.second = seconds % 60
    }

    public static var zero: TimeLength { TimeLength(integer: 0) }
}

public extension Int {
    // convert Millisecond to time tuple
    var time: TimeLength {
        .init(integer: self)
    }
}

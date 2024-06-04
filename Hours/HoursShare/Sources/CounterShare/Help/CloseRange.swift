//
//  File.swift
//
//
//  Created by 张敏超 on 2024/5/31.
//

import Foundation

public extension Range where Bound == Date {
    func isIntersection(_ other: Self) -> Bool {
        lowerBound <= other.upperBound && other.lowerBound <= upperBound
    }

    func intersectionDuration(_ other: Self) -> TimeInterval {
        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)

        if lower >= upper {
            // 如果没有相交，返回0
            return 0
        } else {
            // 计算相交时长
            return upper.timeIntervalSince(lower)
        }
    }
}

public extension ClosedRange where Bound == Date {
    func isIntersection(_ other: Self) -> Bool {
        lowerBound <= other.upperBound && other.lowerBound <= upperBound
    }

    func intersectionDuration(_ other: Self) -> TimeInterval {
        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)

        if lower >= upper {
            // 如果没有相交，返回0
            return 0
        } else {
            // 计算相交时长
            return upper.timeIntervalSince(lower)
        }
    }
}

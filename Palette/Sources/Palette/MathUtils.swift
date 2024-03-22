//
//  MathUtils.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/3.
//

import Foundation

struct MathUtils {
    /// The signum function.
    ///
    /// Returns 1 if num > 0, -1 if num < 0, and 0 if num = 0
    static func signum(num: Double) -> Double {
        if num < 0 {
            return -1
        } else if num == 0 {
            return 0
        } else {
            return 1
        }
    }

    /// The linear interpolation function.
    ///
    /// Returns start if amount = 0 and stop if amount = 1
    static func lerp(start: Double, stop: Double, amount: Double) -> Double {
        (1.0 - amount) * start + amount * stop
    }

    /// Clamps an integer between two integers.
    ///
    /// Returns input when min <= input <= max, and either min or max
    /// otherwise.
    static func clampInt(min: Int, max: Int, input: Int) -> Int {
        if input < min {
            return min
        } else if input > max {
            return max
        }

        return input
    }

    /// Sanitizes a degree measure as a floating-point number.
    ///
    /// Returns a degree measure between 0.0 (inclusive) and 360.0
    /// (exclusive).
    static func sanitize(degrees: Double) -> Double {
        var degrees = degrees.truncatingRemainder(dividingBy: 360.0)
        if degrees < 0 {
            degrees += 360.0
        }
        return degrees
    }

    /// Multiplies a 1x3 row vector with a 3x3 matrix.
    static func matrixMultiply(row: [Double], matrix: [[Double]]) -> [Double] {
        let a = row[0] * matrix[0][0] + row[1] * matrix[0][1] + row[2] * matrix[0][2]
        let b = row[0] * matrix[1][0] + row[1] * matrix[1][1] + row[2] * matrix[1][2]
        let c = row[0] * matrix[2][0] + row[1] * matrix[2][1] + row[2] * matrix[2][2]
        return [a, b, c]
    }
}

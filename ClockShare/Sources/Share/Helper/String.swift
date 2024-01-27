//
//  String.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/9.
//

import Foundation
import UIKit

public extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    var range: NSRange {
        NSRange(location: 0, length: count)
    }

    func boundingSize(with size: CGSize, font: UIFont) -> CGSize {
        let boundingBox = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return CGSize(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
    }

    func height(constrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        self.boundingSize(with: CGSize(width: width, height: .greatestFiniteMagnitude), font: font).height
    }

    func width(constrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        self.boundingSize(with: CGSize(width: .greatestFiniteMagnitude, height: height), font: font).width
    }

    func matchEmails() -> [String]? {
        // 定义电子邮件的正则表达式模式
        let pattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return self.match(pattern: pattern)
    }

    func matchURLs() -> [String]? {
        // 定义 URL 的正则表达式模式
        let pattern = #"((?:https?|ftp)://[^\s/$.?#].[^\s]*)"#

        return self.match(pattern: pattern)
    }

    private func match(pattern: String) -> [String]? {
        // 创建正则表达式对象
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        // 在字符串中搜索匹配项
        let matches = regex?.matches(in: self, options: [], range: self.range)

        // 提取匹配项的字符串
        return matches?.map {
            String(self[Range($0.range, in: self)!])
        }
    }
}

public extension NSAttributedString {
    func height(constrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(constrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}

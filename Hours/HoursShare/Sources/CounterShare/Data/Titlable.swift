//
//  File.swift
//  
//
//  Created by 张敏超 on 2024/7/23.
//

import Foundation

public protocol TitleEntity {
    var emoji: String? { get }
    var name: String { get }
}

public extension TitleEntity {
    var title: String {
        if let emoji = emoji, !emoji.isEmpty {
            return (emoji + " " + self.name).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return self.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

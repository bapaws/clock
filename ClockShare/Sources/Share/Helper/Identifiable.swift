//
//  Identifiable.swift
//
//
//  Created by 张敏超 on 2024/3/30.
//

import Foundation

extension Int: Identifiable {
    public var id: Int { self }
}

extension String: Identifiable {
    public var id: String { self }
}

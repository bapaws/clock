//
//  File.swift
//
//
//  Created by 张敏超 on 2023/12/23.
//

import Foundation
import SwiftUI

public class AppManager: ObservableObject {
    public static let shared = AppManager()

    @Published public var splashDidFinishLoad: Bool = false
}

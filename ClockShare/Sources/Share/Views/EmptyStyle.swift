//
//  SwiftUIView.swift
//
//
//  Created by 张敏超 on 2024/5/11.
//

import SwiftUI
import SwiftUIX

public struct NotFoundView: View {
    public var imageName: String
    public init(imageName: String = "NotFound") {
        self.imageName = imageName
    }

    public var body: some View {
        VStack {
            Image(imageName)
            Spacer()
        }
        .padding(.large)
        .padding(.top, .large)
    }
}

@available(iOS 16.0, *)
struct EmptyStyleModifier: ViewModifier {
    let isEmpty: Bool
    public func body(content: Content) -> some View {
        if isEmpty {
            NotFoundView()
        } else {
            content
        }
    }
}

public extension View {
    @available(iOS 16.0, *)
    func emptyStyle(isEmpty: Bool) -> some View {
        modifier(EmptyStyleModifier(isEmpty: isEmpty))
    }
}

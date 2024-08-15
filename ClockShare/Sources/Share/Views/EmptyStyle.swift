//
//  SwiftUIView.swift
//  
//
//  Created by 张敏超 on 2024/5/11.
//

import SwiftUI
import SwiftUIX

@available(iOS 16.0, *)
struct EmptyStyleModifier: ViewModifier {
    let isEmpty: Bool
    public func body(content: Content) -> some View {
        if isEmpty {
            VStack {
                Spacer()
                Image("NotFound")
                Spacer()
            }
            .padding(.large)
            .padding(.bottom, .large)
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

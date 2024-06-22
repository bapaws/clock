//
//  SwiftUIView.swift
//
//
//  Created by 张敏超 on 2024/6/2.
//

import SwiftUI
import SwiftUIX

public struct NavigationBar<Title: View, Trailing: View>: View {
    let title: Title
    let trailing: Trailing

    public init(title: Title, trailing: Trailing) {
        self.title = title
        self.trailing = trailing
    }

    public var body: some View {
        HStack {
            title
                .foregroundStyle(ui.label)
                .font(.title)

            Spacer()

            trailing
        }
        .padding(.horizontal)
        .padding(.leading, .extraSmall)
        .height(48)
    }
}

public extension NavigationBar where Title == Text {
    init(_ title: String, trailing: @escaping () -> Trailing) {
        self.init(title: Text(title), trailing: trailing())
    }
}

public extension NavigationBar where Title == Text, Trailing == EmptyView {
    init(_ title: String) {
        self.init(title: Text(title), trailing: EmptyView())
    }
}

#Preview {
    NavigationBar("") {
        Button(action: {}, label: {
            Image(systemName: "forward")
        })
    }
}

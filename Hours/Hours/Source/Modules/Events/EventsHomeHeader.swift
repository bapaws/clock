//
//  EventsHomeHeader.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/11.
//

import HoursShare
import SwiftUI

struct EventsHeaderView: View {
    var category: CategoryObject
    var newEventAction: ((CategoryObject) -> Void)?

    var body: some View {
        HStack {
            CategoryView(category: category)
            Spacer()
            if let action = newEventAction {
                Button(action: {
                    action(category)
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .padding(.vertical, .small)
        .padding(.top)
        .background(ui.background)
    }
}

#Preview {
    EventsHeaderView(category: CategoryObject()) { _ in }
}

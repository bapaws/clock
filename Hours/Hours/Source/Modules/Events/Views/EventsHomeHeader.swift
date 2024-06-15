//
//  EventsHomeHeader.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/11.
//

import HoursShare
import SwiftUI

struct EventsHeaderView: View {
    var category: CategoryEntity
    var newEventAction: ((CategoryEntity) -> Void)?

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
        .background(ui.background)
    }
}

#Preview {
    EventsHeaderView(category: CategoryEntity.random()) { _ in }
}

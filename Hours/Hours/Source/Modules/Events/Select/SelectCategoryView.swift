//
//  SelectCategoryView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/12.
//

import Flow
import Foundation
import HoursShare
import RealmSwift
import SwiftUI

struct SelectCategoryView: View {
    @ObservedResults(CategoryObject.self, where: { $0.archivedAt == nil })
    private var categories

    @Binding var selectedCategory: CategoryEntity?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            HFlow(spacing: 12) {
                ForEach(categories) { category in
                    let entity = CategoryEntity(object: category)
                    CategoryView(category: entity)
                        .onTapGesture {
                            selectedCategory = entity
                            dismiss()
                        }
                }
            }
            .padding()
            .padding(.vertical, .large)
        }
        .frame(.greedy, alignment: .leading)
        .background(ui.background)
    }
}

#Preview {
    SelectCategoryView(selectedCategory: .constant(CategoryEntity.random()))
}

//
//  CategoryPickerView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/5.
//

import HoursShare
import RealmSwift
import SwiftUI

struct CategoryIconView: View {
    let category: CategoryObject
    var padding: CGFloat = 4

    var body: some View {
        Group {
            if let icon = category.icon {
                Image(systemName: icon)
                    .frame(width: 25, height: 25, alignment: .center)
            }
            if let emoji = category.emoji {
                Text(emoji)
                    .frame(width: 25, height: 25, alignment: .center)
            }
        }
        .foregroundStyle(category.titleColor)
        .font(.callout)
        .padding(padding)
        .background {
            Circle()
                .fill(category.color)
        }
    }
}

struct CategoryView: View {
    let category: CategoryObject
    var padding: CGFloat = 4

    var body: some View {
        HStack(spacing: 4) {
            CategoryIconView(category: category, padding: padding)

            Text(category.name)
                .font(.callout, weight: .bold)
        }
        .padding(.trailing, .small)
        .background {
            Capsule()
                .fill(category.color.opacity(0.5))
        }
    }
}

struct CategoryPickerView: View {
    var categorys: Results<CategoryObject>
    var onTap: (CategoryObject) -> Void

    var rows: [GridItem] {
        categorys.count > 6 ? [
            GridItem(alignment: .leading),
            GridItem(alignment: .leading),
        ] : [
            GridItem(alignment: .leading),
        ]
    }

    var height: CGFloat {
        categorys.count > 6 ? 112 : 64
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 16) {
                ForEach(categorys) { item in
                    CategoryView(category: item)
                        .onTapGesture {
                            onTap(item)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, .small)
        }
        .scrollDismissesKeyboard(.never)
        .height(height)
        .background(.systemBackground)
    }
}

#Preview {
    let realm = try! Realm()
    let categorys = realm.objects(CategoryObject.self)
    return CategoryPickerView(categorys: categorys, onTap: { _ in })
}

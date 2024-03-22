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
            }
            if let emoji = category.emoji {
                Text(emoji)
            }
        }
        .frame(width: 25, height: 25, alignment: .center)
        .foregroundStyle(category.onSecondaryContainer)
        .padding(.small)
        .background {
            Circle()
                .fill(category.secondaryContainer)
        }
    }
}

struct CategoryView: View {
    let category: CategoryObject
    var padding: CGFloat = 4

    var body: some View {
        HStack(spacing: 4) {
            Group {
                if let icon = category.icon {
                    Image(systemName: icon)
                }
                if let emoji = category.emoji {
                    Text(emoji)
                }
            }
            .font(.body)
            .frame(width: 25, height: 25, alignment: .center)

            Text(category.name)
                .font(.footnote)
        }
        .foregroundStyle(category.onSecondaryContainer)
        .padding(.horizontal, .small)
        .padding(.vertical, .extraSmall)
        .background {
            Capsule()
                .fill(category.secondaryContainer)
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

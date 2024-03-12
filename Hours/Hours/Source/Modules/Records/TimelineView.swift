//
//  TimelineView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/9.
//

import ClockShare
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI
import SwiftUIX

struct TimelineView: View {
    let date: Date
    @State var records: Results<RecordObject>?
    @State var objectNotificationToken: NotificationToken?

    var body: some View {
        if let records = records {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(0 ..< records.count, id: \.self) { index in
                            let record = records[index]
                            HStack(alignment: .top) {
                                VStack(alignment: .trailing, spacing: 10) {
                                    Text(record.startAt.to(format: "HH:mm"))
                                        .font(.body, weight: .bold)
                                    Text(record.endAt.to(format: "HH:mm"))
                                        .font(.callout)
                                        .foregroundStyle(Color.secondaryLabel)
                                }
                                .monospacedDigit()

                                VStack {
                                    if index == 0 {
                                        Image(systemName: "circle.circle")
                                            .font(.title2)
                                            .foregroundStyle(Color.systemMint)
                                    } else {
                                        Circle()
                                            .stroke(Color.systemMint, lineWidth: 2)
                                            .frame(width: 15, height: 15)
                                    }
                                    if index != records.count - 1 {
                                        Rectangle()
                                            .fill(Color.systemMint)
                                            .frame(minWidth: 2, idealWidth: 2, maxWidth: 2, minHeight: 0, maxHeight: .infinity, alignment: .center)
                                    } else {
                                        Spacer()
                                    }
                                }
                                .width(24)
                                if let event = record.event.first {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(event.name)
                                                .font(.title3, weight: .medium)
                                            Spacer()

                                            Text(record.milliseconds.shortTimeLengthText)
                                                .font(.body)
                                                .padding(.vertical, .small)
                                                .foregroundStyle(event.subtitleColor)
                                        }
                                        if let category = event.category {
                                            CategoryView(category: category)
                                        }
                                    }
                                    .padding()
                                    .background(Color.systemBackground)
                                    .cornerRadius(16)
                                    .padding(.bottom)
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.top)
                    .onAppear {
                        proxy.scrollTo(records.count, anchor: .bottom)
                    }
                }
            }
        } else {
            ProgressView()
                .onAppear {
                    records = DBManager.default.getRecords(for: date)

                    objectNotificationToken = records?.observe { change in
                        switch change {
                        case .initial(let collectionType):
                            print(collectionType)
                        case .update(let collectionType, _, _, _):
                            print(collectionType)
                            records = collectionType
                        case .error(let error):
                            print(error)
                        }
                    }
                }
        }
    }
}

#Preview {
    TimelineView(date: Date())
}

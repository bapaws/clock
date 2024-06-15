//
//  EventsHomeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/12.
//

import ClockShare
import HoursShare
import OrderedCollections
import RealmSwift
import SwiftUI
import SwiftUIX

struct EventsHomeView: View {
    // MARK: Category

    @State private var isNewCategoryPresented: Bool = false
    @State private var newestCategoryID: String? = nil

    // MARK: Event

    @State private var newEventSelectCategory: CategoryEntity?
    @State private var isNewEventPresented: Bool = false

    // MARK: Record

    @State private var newRecordSelectEvent: EventEntity?

    // MARK: Timer

    @State private var timerSelectEvent: EventEntity?

    @StateObject private var vm = EventsHomeViewModel()

    @EnvironmentObject var ui: UIManager

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8, pinnedViews: .sectionHeaders) {
                    ForEach(vm.categories.keys.elements) { category in
                        let events = vm.categories[category]!
                        Section {
                            ForEach(events) { event in
                                let entity = EventEntity(object: event)
                                EventItemView(event: entity, playAction: presentTimer)
                                    .onTapGesture {
                                        let view = EventDetailView(event: entity, timerSelectEvent: $timerSelectEvent)
                                        pushView(view, title: entity.name)
                                    }
                                    .contextMenu { menuItems(for: entity) }
                            }

                            ui.background
                        } header: {
                            let categoryEntity = CategoryEntity(object: category)
                            EventsHeaderView(category: categoryEntity) { category in
                                newEventSelectCategory = category
                                isNewEventPresented = true
                            }
                        }
                    }

                    Button {
                        toggleOtherCategory(for: proxy)
                    } label: {
                        HStack {
                            Text(R.string.localizable.showAll())
                            Image(systemName: "chevron.forward")
                                .animation(.easeInOut, value: vm.isOtherCategoriesShow)
                                .rotationEffect(vm.isOtherCategoriesShow ? .degrees(90) : .zero)
                        }
                        .foregroundStyle(ui.secondaryLabel)
                        .padding(.vertical, .large)
                    }
                    .id(R.string.localizable.showAll())

                    if vm.isOtherCategoriesShow {
                        ForEach(vm.otherCategories) { category in
                            let categoryEntity = CategoryEntity(object: category)
                            EventsHeaderView(category: categoryEntity) { category in
                                newEventSelectCategory = category
                                isNewEventPresented = true
                            }
                            .id(categoryEntity.id)
                        }
                    }
                }
                .padding()
                .onChange(of: newestCategoryID) { newValue in
                    guard let value = newValue else { return }

                    vm.isOtherCategoriesShow = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation {
                            proxy.scrollTo(value, anchor: .top)
                        }
                    }
                }
            }
        }
        .background(ui.background)
        .navigationTitle(R.string.localizable.events())
        .toolbar {
            toolbar
        }

        // MARK: Timer

        .fullScreenCover(item: $timerSelectEvent) { event in
            TimerView(event: event)
                .environmentObject(TimerManager.shared)
        }

        // MARK: New Record

        .sheet(item: $newRecordSelectEvent) { event in
            let date = DBManager.default.getRecordEndAt(for: today)
            let startAt = date ?? today.dateBySet(hour: 9, min: 0, secs: 0)!
            let endAt = Date.now < startAt ? startAt.addingTimeInterval(3600) : Date.now
            let view = NewRecordView(event: event, startAt: startAt, endAt: endAt)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .labelsHidden()
            if #available(iOS 16.4, *) {
                view.presentationCornerRadius(32)
            } else {
                view
            }
        }

        // MARK: New Event

        .sheet(isPresented: $isNewEventPresented, onDismiss: {
            newEventSelectCategory = nil
        }) { [newEventSelectCategory] in
            NewEventView(category: newEventSelectCategory)
                .sheetStyle()
        }

        // MARK: New Category

        .sheet(isPresented: $isNewCategoryPresented) {
            NewCategoryView(newestCategoryID: $newestCategoryID)
                .sheetStyle()
        }
    }

    @ToolbarContentBuilder private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button(R.string.localizable.newEvent(), systemImage: "plus", role: nil) {
                    isNewEventPresented = true
                }
                Button(R.string.localizable.newCategory(), systemImage: "folder.badge.plus", role: nil) {
                    isNewCategoryPresented = true
                }

                Divider()

                Button(R.string.localizable.archived(), systemImage: "archivebox.fill", role: nil) {
                    let view = ArchivedEventsView(timerSelectEvent: $timerSelectEvent)
                    pushView(view, title: R.string.localizable.archived())
                }
            } label: {
                Image(systemName: "ellipsis")
                    .padding(.leading)
                    .padding(.vertical)
            }
        }
    }

    @ViewBuilder func menuItems(for event: EventEntity) -> some View {
        Button(action: {
            newRecordSelectEvent = event
        }) {
            Label(R.string.localizable.newRecord(), systemImage: "plus")
        }
        Button(action: {
            timerSelectEvent = event
        }) {
            Label(R.string.localizable.startTimer(), systemImage: "play")
        }
        Divider()

        Button(action: {
            vm.archiveEvent(event)
        }) {
            Label(R.string.localizable.archive(), systemImage: "archivebox")
        }
    }

    private func presentTimer(event: EventEntity) {
        timerSelectEvent = event
    }

    private func toggleOtherCategory(for proxy: ScrollViewProxy) {
        if vm.isOtherCategoriesShow {
            withAnimation {
                vm.isOtherCategoriesShow.toggle()
            }
        } else {
            vm.isOtherCategoriesShow.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation {
                    proxy.scrollTo(R.string.localizable.showAll(), anchor: .top)
                }
            }
        }
    }
}

#Preview {
    EventsHomeView()
}

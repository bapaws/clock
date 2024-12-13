//
//  SettingsWidgetView.swift
//  Hours
//
//  Created by 张敏超 on 2024/12/10.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import SwiftUI
import SwiftUIX
import WidgetKit

@Reducer
struct SettingsWidgetFeature {
    @ObservableState
    struct State: Equatable {
        var widgets: [QuickWidgetEntity] = []

        var editWidgetID: String?
        @Presents var selectedEvents: QuickSelectEventFeature.State?

        var family: WidgetFamily

        var quickWidgets: [QuickWidgetEntity]? {
            family == .systemLarge ?
                Storage.default.quickLargeWidgets :
                Storage.default.quickMediumWidgets
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case appendWidgets([QuickWidgetEntity])
        case appendWidget([QuickCategoryEntity])

        case selectCategory(String, QuickCategoryEntity)

        case onNew
        case onEdit(String)
        case selectedEvents(PresentationAction<QuickSelectEventFeature.Action>)

        case onDeleted(String)

        case storeWidgets([QuickWidgetEntity])
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [quickWidgets = state.quickWidgets] send in
                    if let quickWidgets {
                        await send(.appendWidgets(quickWidgets))
                    }
                }

            case .appendWidgets(let widgets):
                state.widgets = widgets
                return .none

            case .selectCategory(let widgetID, let entity):
                guard let index = state.widgets.firstIndex(where: { $0.id == widgetID }) else { return .none }
                state.widgets[index].selectedCategoryID = entity.id
                return .none

            case .onNew:
                state.selectedEvents = .init(
                    maxCategoryCount: state.family.quickMaxCategoryCount,
                    maxEventCount: state.family.quickMaxEventCount
                )
                return .none

            case .onEdit(let widgetID):
                state.selectedEvents = .init(
                    widget: state.widgets.first { $0.id == widgetID },
                    maxCategoryCount: state.family.quickMaxCategoryCount,
                    maxEventCount: state.family.quickMaxEventCount
                )
                state.editWidgetID = widgetID
                return .none

            case .selectedEvents(.presented(.onCompleted(let widget))):
                guard var widget else { return .none }

                if widget.selectedCategoryID == nil {
                    widget.selectedCategoryID = widget.categories.first?.id
                }
                if let index = state.widgets.firstIndex(where: { $0.id == widget.id }) {
                    state.widgets[index] = widget
                } else {
                    state.widgets.append(widget)
                }

                return .run { [quickWidgets = state.quickWidgets, widget] send in
                    guard var quickWidgets else {
                        await send(.storeWidgets([widget]))
                        return
                    }
                    if let index = quickWidgets.firstIndex(where: { $0.id == widget.id }) {
                        quickWidgets[index] = widget
                    } else {
                        quickWidgets.append(widget)
                    }
                    await send(.storeWidgets(quickWidgets))
                }

            case .onDeleted(let widgetID):
                state.widgets.removeAll { $0.id == widgetID }
                return .run { [quickWidgets = state.quickWidgets] send in
                    guard var quickWidgets else { return }
                    quickWidgets.removeAll { $0.id == widgetID }
                    await send(.storeWidgets(quickWidgets))
                }

            case .storeWidgets(let widgets):
                return .run { [family = state.family] _ in
                    if family == .systemLarge {
                        Storage.default.quickLargeWidgets = widgets
                    } else {
                        Storage.default.quickMediumWidgets = widgets
                    }

                    WidgetCenter.shared.reloadAllTimelines()
                }

            case .binding(\.widgets):
                return .run { [widgets = state.widgets] send in
                    await send(.storeWidgets(widgets.filter { $0.categories.count > 0 }))
                }

            default:
                return .none
            }
        }
        .ifLet(\.$selectedEvents, action: \.selectedEvents) {
            QuickSelectEventFeature()
        }
    }
}

struct SettingsWidgetView: View {
    @Perception.Bindable var store: StoreOf<SettingsWidgetFeature>

    var columnCount = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { proxy in
                let displayWidth = proxy.size.width - 48
                let displaySize = getDisplaySize(width: displayWidth)
                VStack {
                    ScrollView {
                        /// 这里在 ForEach 种添加 WithPerceptionTracking 会导致删除崩溃
                        WithPerceptionTracking {
                            getGrid(displaySize: displaySize)
                        }
                    }
                    Button {
                        store.send(.onNew)
                    } label: {
                        Label(L10n.new, systemImage: .plus)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                            .foregroundStyle(Color.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                    .padding(.vertical, .small)
                }
            }
            .onAppear {
                store.send(.onAppear)
            }

            .sheet(item: $store.scope(state: \.selectedEvents, action: \.selectedEvents)) {
                QuickSelectEventView(store: $0)
            }
        }
    }

    func getGrid(displaySize: CGSize) -> some View {
        Grid {
            ForEach(0 ..< Int(ceil(Double(store.widgets.count) / Double(columnCount))), id: \.self) { rowIndex in
                GridRow {
                    ForEach(0 ..< columnCount, id: \.self) { columnIndex in
                        let index = rowIndex * columnCount + columnIndex
                        if index >= store.widgets.count {
                            Color.clear
                                .frame(displaySize)
                        } else {
                            let widget = store.widgets[index]
                            let entry = QuickTimelineEntry(
                                family: store.family,
                                displaySize: displaySize,
                                widget: widget
                            )
                            VStack {
                                HStack {
                                    TextField(widget.id, text: $store.widgets[index].title)

                                    Button {
                                        store.send(.onEdit(widget.id))
                                    } label: {
                                        Image(systemName: "folder.badge.plus")
                                            .padding(.horizontal)
                                            .padding(.vertical, .small)
                                    }

                                    if widget.id != QuickWidgetEntity.defaultID {
                                        Button {
                                            store.send(.onDeleted(widget.id), animation: .bouncy)
                                        } label: {
                                            Image(systemName: .trash)
                                                .padding(.horizontal)
                                                .padding(.vertical, .small)
                                                .foregroundStyle(Color.systemRed)
                                        }
                                    }
                                }
                                .padding(.horizontal, .small)

                                QuickEntryView(entry: entry) {
                                    store.send(.selectCategory(widget.id, $0), animation: .bouncy)
                                }
                                .frame(displaySize)
                                .background(ui.secondaryBackground)
                                .cornerRadius(24)
                                .padding(.bottom)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
    }

    func getDisplaySize(width: Double) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return store.family == .systemLarge ?
                CGSize(width: width, height: width) :
                CGSize(width: width, height: floor(width / 2))
        }
        let displayWidth = (width - 16) / 2
        return store.family == .systemLarge ?
            CGSize(width: displayWidth, height: displayWidth) :
            CGSize(width: displayWidth, height: floor(displayWidth / 2))
    }
}

// #Preview {
//    SettingsWidgetView()
// }

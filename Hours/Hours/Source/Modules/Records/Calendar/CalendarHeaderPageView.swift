//
//  CalendarHeaderPageView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/16.
//

import ComposableArchitecture
import HoursShare
import SwiftDate
import SwiftUI

@Reducer
struct CalendarHeaderPageFeature {
    @ObservableState
    struct State: Equatable {
        @Shared(.recordsHomeCurrentState) var home = .init()

        var isNewRecordPresented: Bool = false

        var isDatePickerPresented: Bool = false

        var currentDate: Date {
            set { home.date = newValue }
            get { home.date }
        }

        var previousDays: [Date] { home.previousDays }
        var currentDays: [Date] { home.currentDays }
        var nextDays: [Date] { home.nextDays }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onCurrentDateTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onCurrentDateTapped:
                state.isDatePickerPresented = true
                return .none

            case .binding(\.home):
                debugPrint(state.home.date)
                return .none

            default:
                return .none
            }
        }
    }
}

struct CalendarHeaderPageView: View {
    @Perception.Bindable var store: StoreOf<CalendarHeaderPageFeature>

    let onNewRecordTapped: () -> Void

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading) {
                HStack {
                    NavigationBar(
                        title: Button {
                            store.send(.onCurrentDateTapped, animation: .default)
                        } label: {
                            HStack {
                                Text(store.currentDate.to(format: "MMMyyyy"))
                                Image(systemName: "chevron.forward")
                                    .font(.body)
                                    .rotationEffect(store.isDatePickerPresented ? .degrees(90) : .zero)
                                    .animation(.default, value: store.isDatePickerPresented)
                            }
                        },
                        trailing: Button(systemImage: .plus, action: onNewRecordTapped)
                    )
                }

                InfinitePageView(
                    selection: $store.home.date.animation(),
                    backward: { $0.dateAt(.startOfWeek).dateAt(.yesterdayAtStart) },
                    forward: { $0.dateAt(.endOfWeek).dateAt(.tomorrowAtStart) }
                ) { date in
                    WithPerceptionTracking {
                        if store.currentDate > date {
                            CalendarHeaderView(
                                currentDate: $store.home.date.animation(),
                                days: store.previousDays
                            )
                        } else if store.currentDate < date {
                            CalendarHeaderView(
                                currentDate: $store.home.date.animation(),
                                days: store.nextDays
                            )
                        } else {
                            CalendarHeaderView(
                                currentDate: $store.home.date.animation(),
                                days: store.currentDays
                            )
                        }
                    }
                }
            }
            .height(102)
            .sheet(isPresented: $store.isDatePickerPresented) {
                DatePicker("Enter", selection: $store.currentDate.animation(), displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .presentationDetents([.height(400)])
                    .presentationDragIndicator(.visible)
                    .labelsHidden()
            }
        }
    }
}

#Preview {
    CalendarHeaderPageView(
        store: .init(
            initialState: .init(),
            reducer: { CalendarHeaderPageFeature() }
        ),
        onNewRecordTapped: {}
    )
}

//
//  TimerView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/6.
//

import ClockShare
import HoursShare
import RealmSwift
import SwiftUI
import SwiftUIX

struct TimerView: View {
    @Binding var task: EventObject?
    @Binding var isPresented: Bool

    @State var startAt: Date = .init()

    var time: Time { manager.time }

    @EnvironmentObject var manager: TimerManager

    var body: some View {
        GeometryReader { proxy in
            let minLenght = min(proxy.size.width, proxy.size.height)
            VStack {
                Spacer()

                Text(task?.name ?? R.string.localizable.tasks())
                    .font(.largeTitle)
                    .frame(width: .greedy)
                if let category = task?.category {
                    CategoryView(category: category)
                }

                Spacer()

                HStack {
                    let seconds = time.seconds
                    Text("\(time.hourTens)\(time.hourOnes)")
                        .foregroundColor(seconds < 3600 ? .lightGray : .darkGray)
                    Text(":")
                        .foregroundColor(seconds < 3600 ? .lightGray : .darkGray)
                    Text("\(time.minuteTens)\(time.minuteOnes)")
                        .foregroundColor(seconds < 60 ? .lightGray : .darkGray)
                    Text(":")
                        .foregroundColor(seconds < 60 ? .lightGray : .darkGray)
                    Text("\(time.secondTens)\(time.secondOnes)")
                        .foregroundColor(seconds == 0 ? .lightGray : .darkGray)
                }
                .font(.system(size: floor(minLenght / 8), design: .rounded), weight: .bold)
                .monospacedDigit()

                Spacer(minLength: floor(minLenght * 0.6))

                Button {
                    isPresented = false

                    guard let realm = task?.realm else {
                        manager.stop()
                        return
                    }
                    try? realm.write {
                        let item = RecordObject(creationMode: .timer, startAt: self.startAt, milliseconds: time.milliseconds)
                        realm.add(item)

                        task?.items.append(item)
                    }
                    manager.stop()
                } label: {
                    Text(R.string.localizable.finish())
                        .padding(.vertical, .small)
                        .padding(.horizontal, .large)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(white: 0.5), lineWidth: 1)
                        }
                }

                Spacer()
            }
        }
        .ifLet(task?.color) {
            $0.background(LinearGradient(gradient: Gradient(colors: [$1, Color.white]), startPoint: .top, endPoint: .bottom))
        }
        .onAppear {
            manager.start()
            startAt = time.date
        }
    }
}

#Preview {
    TimerView(task: .constant(EventObject(emoji: "👌", name: "Work", hex: HexObject(hex: "#757573"))), isPresented: .constant(false))
        .environmentObject(TimerManager.shared)
}

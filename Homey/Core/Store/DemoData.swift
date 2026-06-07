//
//  DemoData.swift
//  Homey
//
//  Seed data for the local demo. Replaced by real backend data later.
//

import Foundation

enum DemoData {
    struct Seed {
        var household: Household
        var members: [Member]
        var chores: [Chore]
        var completions: [ChoreCompletion]
        var currentMemberId: UUID
    }

    static var demo: Seed {
        let mom = Member(id: UUID(), name: "Mom", emoji: "👩", role: .admin)
        let dad = Member(id: UUID(), name: "Dad", emoji: "👨")
        let ana = Member(id: UUID(), name: "Ana", emoji: "👧")
        let ama = Member(id: UUID(), name: "Ama", emoji: "🧒")
        let members = [mom, dad, ana, ama]
        let household = Household(
            id: UUID(),
            name: "Ana's Family House",
            memberIds: members.map(\.id)
        )

        let calendar = Calendar.current
        let today = Date()
        func date(_ dayOffset: Int, _ hour: Int, _ minute: Int = 0) -> Date {
            let base = calendar.date(byAdding: .day, value: dayOffset, to: today) ?? today
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: base) ?? base
        }

        let hid = household.id
        let chores: [Chore] = [
            Chore(id: UUID(), householdId: hid, title: "Clean bathroom", notes: "Don't forget the bedsheets.", assigneeId: nil, dueDate: date(0, 17), status: .available),
            Chore(id: UUID(), householdId: hid, title: "Wash dishes", assigneeId: ana.id, dueDate: date(0, 20), status: .inProgress),
            Chore(id: UUID(), householdId: hid, title: "Mop the floor", assigneeId: dad.id, dueDate: date(-1, 21), status: .done),
            Chore(id: UUID(), householdId: hid, title: "Vacuum living room", assigneeId: ama.id, dueDate: date(-1, 14), status: .available),
            Chore(id: UUID(), householdId: hid, title: "Take out trash", assigneeId: nil, dueDate: date(1, 9), status: .available),
            Chore(id: UUID(), householdId: hid, title: "Water the plants", assigneeId: mom.id, dueDate: date(1, 8), status: .available),
            Chore(id: UUID(), householdId: hid, title: "Grocery shopping", assigneeId: mom.id, dueDate: date(2, 11), status: .available),
        ]
        let completions = [
            ChoreCompletion(id: UUID(), choreId: chores[2].id, completedBy: dad.id, completedAt: date(-1, 20))
        ]

        return Seed(
            household: household,
            members: members,
            chores: chores,
            completions: completions,
            currentMemberId: mom.id
        )
    }
}

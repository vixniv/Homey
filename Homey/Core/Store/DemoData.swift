//
//  DemoData.swift
//  Homey
//
//  Seed data for previews and tests (InMemoryStore). The live app uses Supabase.
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
        let householdId = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
        let momId = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
        let dadId = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
        let anaId = UUID(uuidString: "44444444-4444-4444-4444-444444444444")!
        let amaId = UUID(uuidString: "55555555-5555-5555-5555-555555555555")!

        let members = [
            Member(id: momId, householdId: householdId, name: "Mom", emoji: "👩", role: .admin),
            Member(id: dadId, householdId: householdId, name: "Dad", emoji: "👨"),
            Member(id: anaId, householdId: householdId, name: "Ana", emoji: "👧"),
            Member(id: amaId, householdId: householdId, name: "Ama", emoji: "🧒"),
        ]
        let household = Household(id: householdId, name: "Ana's Family House")

        let calendar = Calendar.current
        let today = Date()
        func date(_ dayOffset: Int, _ hour: Int, _ minute: Int = 0) -> Date {
            let base = calendar.date(byAdding: .day, value: dayOffset, to: today) ?? today
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: base) ?? base
        }

        let chores: [Chore] = [
            Chore(id: UUID(), householdId: householdId, title: "Clean bathroom", notes: "Don't forget the bedsheets.", assigneeId: nil, dueDate: date(0, 17), status: .available),
            Chore(id: UUID(), householdId: householdId, title: "Wash dishes", assigneeId: anaId, dueDate: date(0, 20), status: .inProgress),
            Chore(id: UUID(), householdId: householdId, title: "Mop the floor", assigneeId: dadId, dueDate: date(-1, 21), status: .done),
            Chore(id: UUID(), householdId: householdId, title: "Vacuum living room", assigneeId: amaId, dueDate: date(-1, 14), status: .available),
            Chore(id: UUID(), householdId: householdId, title: "Take out trash", assigneeId: nil, dueDate: date(1, 9), status: .available),
            Chore(id: UUID(), householdId: householdId, title: "Water the plants", assigneeId: momId, dueDate: date(1, 8), status: .available),
            Chore(id: UUID(), householdId: householdId, title: "Grocery shopping", assigneeId: momId, dueDate: date(2, 11), status: .available),
        ]
        let completions = [
            ChoreCompletion(id: UUID(), choreId: chores[2].id, completedBy: dadId, completedAt: date(-1, 20))
        ]

        return Seed(
            household: household,
            members: members,
            chores: chores,
            completions: completions,
            currentMemberId: anaId
        )
    }
}

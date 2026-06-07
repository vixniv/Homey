//
//  HomeViewModel.swift
//  Homey
//

import Dependencies
import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    @ObservationIgnored @Dependency(\.choreClient) private var choreClient
    @ObservationIgnored @Dependency(\.householdClient) private var householdClient
    @ObservationIgnored @Dependency(\.date.now) private var now

    var householdName = ""
    var members: [Member] = []
    var currentMemberId: UUID?
    var selectedDate = Date()
    var selectedMemberId: UUID?            // nil = everyone
    private var chores: [Chore] = []

    var rows: [TaskItem] {
        let calendar = Calendar(identifier: .gregorian)
        let target = calendar.startOfDay(for: selectedDate)
        return chores
            .filter { calendar.startOfDay(for: $0.dueDate) == target }
            .filter { selectedMemberId == nil || $0.assigneeId == selectedMemberId }
            .map(row(for:))
    }

    func load() async {
        async let household = householdClient.household()
        async let members = householdClient.members()
        async let currentMemberId = householdClient.currentMemberId()
        async let chores = choreClient.allChores()
        self.householdName = await household.name
        self.members = await members
        self.currentMemberId = await currentMemberId
        self.chores = await chores
    }

    func grab(_ row: TaskItem) async {
        guard let me = currentMemberId else { return }
        await choreClient.grab(row.id, me)
        await reloadChores()
    }

    func delete(_ row: TaskItem) async {
        await choreClient.delete(row.id)
        await reloadChores()
    }

    func chore(for row: TaskItem) -> Chore? {
        chores.first { $0.id == row.id }
    }

    private func reloadChores() async {
        chores = await choreClient.allChores()
    }

    private func row(for chore: Chore) -> TaskItem {
        let state: TaskState
        if chore.status == .done {
            state = .done
        } else if chore.dueDate < now {
            state = .late
        } else if chore.status == .inProgress || chore.status == .assigned {
            state = .inProgress
        } else {
            state = .available
        }
        let emoji = members.first { $0.id == chore.assigneeId }?.emoji ?? ""
        return TaskItem(
            id: chore.id,
            title: chore.title,
            dueLabel: dueLabel(for: chore.dueDate),
            state: state,
            assigneeInitials: emoji,
            assigneeId: chore.assigneeId
        )
    }

    private func dueLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return "Before \(formatter.string(from: date))"
    }
}

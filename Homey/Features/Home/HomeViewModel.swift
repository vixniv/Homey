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
    var selectedMemberId: UUID?          // nil = everyone (list-header filter)
    var errorMessage: String?
    private var chores: [Chore] = []

    private let calendar = Calendar(identifier: .gregorian)

    var currentMember: Member? {
        members.first { $0.id == currentMemberId }
    }

    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        return formatter.string(from: selectedDate)
    }

    var weekDays: [Date] {
        let today = calendar.startOfDay(for: now)
        let weekday = calendar.component(.weekday, from: today) // 1=Sun ... 7=Sat
        let daysFromMonday = (weekday + 5) % 7
        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
            return [today]
        }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
    }

    private var choresOnSelectedDate: [Chore] {
        let target = calendar.startOfDay(for: selectedDate)
        return chores.filter { calendar.startOfDay(for: $0.dueDate) == target }
    }

    var rows: [TaskItem] {
        choresOnSelectedDate
            .filter { selectedMemberId == nil || $0.assigneeId == selectedMemberId }
            .map(row(for:))
    }

    func selectDate(_ date: Date) {
        selectedDate = date
    }

    func load() async {
        do {
            async let household = householdClient.household()
            async let members = householdClient.members()
            async let currentMemberId = householdClient.currentMemberId()
            async let chores = choreClient.allChores()
            self.householdName = try await household.name
            self.members = try await members
            self.currentMemberId = try await currentMemberId
            self.chores = try await chores
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refresh() async {
        await load()
    }

    func grab(_ row: TaskItem) async {
        guard let me = currentMemberId else { return }
        do {
            try await choreClient.grab(choreId: row.id, by: me)
            try await reloadChores()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(_ row: TaskItem) async {
        do {
            try await choreClient.delete(choreId: row.id)
            try await reloadChores()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func chore(for row: TaskItem) -> Chore? {
        chores.first { $0.id == row.id }
    }

    private func reloadChores() async throws {
        chores = try await choreClient.allChores()
    }

    private func row(for chore: Chore) -> TaskItem {
        let state: TaskState
        if chore.status == .done {
            state = .done
        } else if chore.dueDate < now {
            state = .late
        } else if chore.status == .inProgress {
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

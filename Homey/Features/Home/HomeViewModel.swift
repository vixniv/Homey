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
    @ObservationIgnored @Dependency(\.householdStore) private var store
    @ObservationIgnored @Dependency(\.date.now) private var now

    var selectedDate = Date()
    var selectedMemberId: UUID?

    private let calendar = Calendar(identifier: .gregorian)

    var householdName: String { store.householdName }
    var members: [Member] { store.members }
    var currentMemberId: UUID? { store.currentMemberId }
    var isLoading: Bool { store.isLoading }

    var errorMessage: String? {
        get { store.errorMessage }
        set { store.errorMessage = newValue }
    }

    var currentMember: Member? { members.first { $0.id == currentMemberId } }

    var monthTitle: String {
        let f = DateFormatter(); f.dateFormat = "LLLL"
        return f.string(from: selectedDate)
    }

    var weekDays: [Date] {
        let today = calendar.startOfDay(for: now)
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else { return [today] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
    }

    private var occurrencesOnSelectedDate: [Occurrence] {
        store.occurrences(on: selectedDate)
    }

    var rows: [TaskItem] {
        occurrencesOnSelectedDate
            .filter { selectedMemberId == nil || $0.assigneeId == selectedMemberId }
            .map(row(for:))
    }

    func selectDate(_ date: Date) { selectedDate = date }

    func load() async { await store.load() }
    func refresh() async { await store.load() }

    func grab(_ row: TaskItem) async {
        guard let me = currentMemberId else { return }
        await store.grab(choreId: row.choreId, by: me, on: row.occurrenceDate)
    }

    func delete(_ row: TaskItem) async {
        await store.delete(choreId: row.choreId)   // recurring: deletes the series
    }

    /// The (chore, date) to open in detail for a tapped row.
    func selection(for row: TaskItem) -> SelectedOccurrence? {
        guard let chore = store.chores.first(where: { $0.id == row.choreId }) else { return nil }
        return SelectedOccurrence(id: row.id, chore: chore, date: row.occurrenceDate)
    }

    private func row(for occ: Occurrence) -> TaskItem {
        let state: TaskState
        if occ.status == .done {
            state = .done
        } else if occ.assigneeId == nil {
            state = .available
        } else if occ.dueDate < now {
            state = .late
        } else if occ.status == .inProgress {
            state = .inProgress
        } else {
            state = .available
        }
        let emoji = members.first { $0.id == occ.assigneeId }?.emoji ?? ""
        return TaskItem(
            id: occ.id,
            choreId: occ.chore.id,
            occurrenceDate: occ.isRecurring ? occ.date : nil,
            title: occ.chore.title,
            dueLabel: dueLabel(for: occ.dueDate),
            state: state,
            assigneeInitials: emoji,
            assigneeId: occ.assigneeId
        )
    }

    private func dueLabel(for date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "h:mm a"
        return "Before \(f.string(from: date))"
    }
}

/// Identifiable selection for the detail cover: a chore on an optional day.
struct SelectedOccurrence: Identifiable {
    let id: String
    let chore: Chore
    let date: Date?
}

//
//  ChoreDetailViewModel.swift
//  Homey
//

import Dependencies
import Foundation
import Observation

@MainActor
@Observable
final class ChoreDetailViewModel {
    @ObservationIgnored @Dependency(\.householdStore) private var store
    @ObservationIgnored @Dependency(\.date.now) private var now

    private let choreId: UUID
    private let occurrenceDate: Date?    // nil = one-off chore
    private let initialChore: Chore

    init(chore: Chore, date: Date? = nil) {
        self.choreId = chore.id
        self.occurrenceDate = date
        self.initialChore = chore
    }

    private var occurrence: Occurrence? { store.resolvedOccurrence(choreId: choreId, on: occurrenceDate) }

    var chore: Chore { occurrence?.chore ?? initialChore }
    var householdName: String { store.householdName }
    var assignee: Member? { store.members.first { $0.id == (occurrence?.assigneeId) } }

    var completion: ChoreCompletion? {
        if let date = occurrenceDate {
            let key = HouseholdStore.dayKey(date)
            return store.completions.first { $0.choreId == choreId && HouseholdStore.dayKey($0.completedAt) == key }
        }
        return store.completions.first { $0.choreId == choreId }
    }
    var completedBy: Member? { store.members.first { $0.id == completion?.completedBy } }

    var errorMessage: String? {
        get { store.errorMessage }
        set { store.errorMessage = newValue }
    }

    var state: TaskState {
        let status = occurrence?.status ?? chore.status
        let due = occurrence?.dueDate ?? chore.dueDate
        let assignee = occurrence?.assigneeId
        if status == .done { return .done }
        if assignee == nil { return .available }
        if due < now { return .late }
        if status == .inProgress { return .inProgress }
        return .available
    }

    func load() async {
        if store.members.isEmpty { await store.load() }
    }

    func primaryAction() async {
        guard let me = store.currentMemberId else { return }
        switch state {
        case .available:
            await store.grab(choreId: choreId, by: me, on: occurrenceDate)
        case .inProgress, .late:
            await store.finish(choreId: choreId, by: me, at: now, on: occurrenceDate)
        case .done:
            break
        }
    }
}

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
    private let initialChore: Chore

    init(chore: Chore) {
        self.choreId = chore.id
        self.initialChore = chore
    }

    // Live read-through: falls back to the snapshot if the store hasn't loaded.
    var chore: Chore { store.chores.first { $0.id == choreId } ?? initialChore }
    var householdName: String { store.householdName }
    var assignee: Member? { store.members.first { $0.id == chore.assigneeId } }
    var completion: ChoreCompletion? { store.completions.first { $0.choreId == choreId } }
    var completedBy: Member? { store.members.first { $0.id == completion?.completedBy } }

    var errorMessage: String? {
        get { store.errorMessage }
        set { store.errorMessage = newValue }
    }

    var state: TaskState {
        if chore.status == .done { return .done }
        if chore.dueDate < now { return .late }
        if chore.status == .inProgress { return .inProgress }
        return .available
    }

    func load() async {
        if store.members.isEmpty { await store.load() }
    }

    func primaryAction() async {
        guard let me = store.currentMemberId else { return }
        switch state {
        case .available:
            await store.grab(choreId: choreId, by: me)
        case .inProgress, .late:
            await store.finish(choreId: choreId, by: me, at: now)
        case .done:
            break
        }
    }
}

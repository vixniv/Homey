//
//  InMemoryStore.swift
//  Homey
//
//  In-memory source of truth for the demo. Swapped for a real backend
//  (e.g. Supabase) later behind the feature clients.
//

import Dependencies
import Foundation

actor InMemoryStore {
    private(set) var household: Household
    private(set) var members: [Member]
    private(set) var chores: [Chore]
    private(set) var completions: [ChoreCompletion]
    let currentMemberId: UUID

    init(seed: DemoData.Seed) {
        self.household = seed.household
        self.members = seed.members
        self.chores = seed.chores
        self.completions = seed.completions
        self.currentMemberId = seed.currentMemberId
    }

    // MARK: - Reads

    func loadHousehold() -> Household { household }

    func loadMembers() -> [Member] { members }

    func allChores() -> [Chore] {
        chores.sorted { $0.dueDate < $1.dueDate }
    }

    func loadCompletions() -> [ChoreCompletion] { completions }

    // MARK: - Writes

    func add(_ chore: Chore) {
        chores.append(chore)
    }

    func grab(choreId: UUID, by memberId: UUID) {
        guard let index = chores.firstIndex(where: { $0.id == choreId }) else { return }
        chores[index].assigneeId = memberId
        chores[index].status = .inProgress
    }

    func finish(choreId: UUID, by memberId: UUID, at date: Date) {
        guard let index = chores.firstIndex(where: { $0.id == choreId }) else { return }
        chores[index].status = .done
        if chores[index].assigneeId == nil {
            chores[index].assigneeId = memberId
        }
        completions.append(
            ChoreCompletion(id: UUID(), choreId: choreId, completedBy: memberId, completedAt: date)
        )
    }

    func delete(choreId: UUID) {
        chores.removeAll { $0.id == choreId }
    }

    func update(_ chore: Chore) {
        guard let index = chores.firstIndex(where: { $0.id == chore.id }) else { return }
        chores[index] = chore
    }
}

// MARK: - Dependency

private enum InMemoryStoreKey: DependencyKey {
    static var liveValue: InMemoryStore { InMemoryStore(seed: DemoData.demo) }
    static var previewValue: InMemoryStore { InMemoryStore(seed: DemoData.demo) }
}

extension DependencyValues {
    var homeyStore: InMemoryStore {
        get { self[InMemoryStoreKey.self] }
        set { self[InMemoryStoreKey.self] = newValue }
    }
}

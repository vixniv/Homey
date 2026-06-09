//
//  HouseholdStore.swift
//  Homey
//
//  Single in-memory source of truth observed by every screen. Mutations are
//  applied locally first (optimistic), pushed to Supabase via the clients, and
//  rolled back on error. This is distinct from InMemoryStore (\.homeyStore),
//  which only backs the clients' preview/test values.
//

import Dependencies
import Foundation
import Observation

@MainActor
@Observable
final class HouseholdStore {
    @ObservationIgnored @Dependency(\.choreClient) private var choreClient
    @ObservationIgnored @Dependency(\.householdClient) private var householdClient

    var householdId: UUID?
    var householdName = ""
    var members: [Member] = []
    var chores: [Chore] = []
    var completions: [ChoreCompletion] = []
    var currentMemberId: UUID?
    var isLoading = false
    var errorMessage: String?

    // Trivial nonisolated init so the singleton `static let` can be constructed
    // outside the main actor; all stored properties have Sendable defaults.
    nonisolated init() {}

    func load() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            async let householdTask = householdClient.household()
            async let membersTask = householdClient.members()
            async let currentMemberTask = householdClient.currentMemberId()
            async let choresTask = choreClient.allChores()
            async let completionsTask = choreClient.completions()

            let household = try await householdTask
            householdId = household.id
            householdName = household.name
            members = try await membersTask
            currentMemberId = try await currentMemberTask
            chores = (try await choresTask).sorted { $0.dueDate < $1.dueDate }
            completions = try await completionsTask
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func create(_ chore: Chore) async {
        errorMessage = nil
        let snapshot = chores
        chores.append(chore)
        chores.sort { $0.dueDate < $1.dueDate }
        do {
            try await choreClient.create(chore)
        } catch {
            chores = snapshot
            errorMessage = error.localizedDescription
        }
    }

    func grab(choreId: UUID, by memberId: UUID) async {
        errorMessage = nil
        let snapshot = chores
        guard let i = chores.firstIndex(where: { $0.id == choreId }) else { return }
        chores[i].assigneeId = memberId
        chores[i].status = .inProgress
        do {
            try await choreClient.grab(choreId: choreId, by: memberId)
        } catch {
            chores = snapshot
            errorMessage = error.localizedDescription
        }
    }

    func finish(choreId: UUID, by memberId: UUID, at date: Date) async {
        errorMessage = nil
        let choresSnap = chores
        let completionsSnap = completions
        guard let i = chores.firstIndex(where: { $0.id == choreId }) else { return }
        chores[i].status = .done
        completions.append(
            ChoreCompletion(id: UUID(), choreId: choreId, completedBy: memberId, completedAt: date)
        )
        do {
            try await choreClient.finish(choreId: choreId, by: memberId, at: date)
        } catch {
            chores = choresSnap
            completions = completionsSnap
            errorMessage = error.localizedDescription
        }
    }

    func update(_ chore: Chore) async {
        errorMessage = nil
        let snapshot = chores
        guard let i = chores.firstIndex(where: { $0.id == chore.id }) else { return }
        chores[i] = chore
        chores.sort { $0.dueDate < $1.dueDate }
        do {
            try await choreClient.update(chore)
        } catch {
            chores = snapshot
            errorMessage = error.localizedDescription
        }
    }

    func delete(choreId: UUID) async {
        errorMessage = nil
        let choresSnap = chores
        let completionsSnap = completions
        chores.removeAll { $0.id == choreId }
        completions.removeAll { $0.choreId == choreId }
        do {
            try await choreClient.delete(choreId: choreId)
        } catch {
            chores = choresSnap
            completions = completionsSnap
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Dependency

private enum HouseholdStoreKey: DependencyKey {
    static let liveValue = HouseholdStore()
    static var previewValue: HouseholdStore { liveValue }
}

extension DependencyValues {
    var householdStore: HouseholdStore {
        get { self[HouseholdStoreKey.self] }
        set { self[HouseholdStoreKey.self] = newValue }
    }
}

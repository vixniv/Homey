//
//  ChoreClient.swift
//  Homey
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
struct ChoreClient: Sendable {
    var allChores: @Sendable () async throws -> [Chore]
    var completions: @Sendable () async throws -> [ChoreCompletion]
    var create: @Sendable (_ chore: Chore) async throws -> Void
    var grab: @Sendable (_ choreId: UUID, _ by: UUID) async throws -> Void
    var finish: @Sendable (_ choreId: UUID, _ by: UUID, _ at: Date) async throws -> Void
    var delete: @Sendable (_ choreId: UUID) async throws -> Void
    var update: @Sendable (_ chore: Chore) async throws -> Void
    var allOccurrences: @Sendable () async throws -> [ChoreOccurrence]
    var upsertOccurrence: @Sendable (_ occurrence: ChoreOccurrence) async throws -> Void
}

extension ChoreClient {
    static var previewValue: ChoreClient { inMemoryValue }

    /// In-memory implementation backing previews and tests.
    static var inMemoryValue: ChoreClient {
        ChoreClient(
            allChores: {
                @Dependency(\.homeyStore) var store
                return await store.allChores()
            },
            completions: {
                @Dependency(\.homeyStore) var store
                return await store.loadCompletions()
            },
            create: { chore in
                @Dependency(\.homeyStore) var store
                await store.add(chore)
            },
            grab: { choreId, memberId in
                @Dependency(\.homeyStore) var store
                await store.grab(choreId: choreId, by: memberId)
            },
            finish: { choreId, memberId, date in
                @Dependency(\.homeyStore) var store
                await store.finish(choreId: choreId, by: memberId, at: date)
            },
            delete: { choreId in
                @Dependency(\.homeyStore) var store
                await store.delete(choreId: choreId)
            },
            update: { chore in
                @Dependency(\.homeyStore) var store
                await store.update(chore)
            },
            allOccurrences: {
                @Dependency(\.homeyStore) var store
                return await store.allOccurrences()
            },
            upsertOccurrence: { occurrence in
                @Dependency(\.homeyStore) var store
                await store.upsertOccurrence(occurrence)
            }
        )
    }
}

extension DependencyValues {
    var choreClient: ChoreClient {
        get { self[ChoreClient.self] }
        set { self[ChoreClient.self] = newValue }
    }
}

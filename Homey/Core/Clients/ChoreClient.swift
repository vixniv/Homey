//
//  ChoreClient.swift
//  Homey
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
struct ChoreClient: Sendable {
    var allChores: @Sendable () async -> [Chore] = { [] }
    var completions: @Sendable () async -> [ChoreCompletion] = { [] }
    var create: @Sendable (_ chore: Chore) async -> Void
    var grab: @Sendable (_ choreId: UUID, _ memberId: UUID) async -> Void
    var finish: @Sendable (_ choreId: UUID, _ memberId: UUID, _ at: Date) async -> Void
    var delete: @Sendable (_ choreId: UUID) async -> Void
}

extension ChoreClient: DependencyKey {
    static var liveValue: ChoreClient {
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
            }
        )
    }
    static var previewValue: ChoreClient { liveValue }
}

extension DependencyValues {
    var choreClient: ChoreClient {
        get { self[ChoreClient.self] }
        set { self[ChoreClient.self] = newValue }
    }
}

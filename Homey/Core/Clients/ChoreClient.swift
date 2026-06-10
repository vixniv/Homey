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

extension DependencyValues {
    var choreClient: ChoreClient {
        get { self[ChoreClient.self] }
        set { self[ChoreClient.self] = newValue }
    }
}

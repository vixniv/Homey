//
//  HouseholdClient.swift
//  Homey
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
struct HouseholdClient: Sendable {
    var household: @Sendable () async throws -> Household
    var members: @Sendable () async throws -> [Member]
    var currentMemberId: @Sendable () async throws -> UUID
}

extension HouseholdClient {
    static var previewValue: HouseholdClient { inMemoryValue }

    /// In-memory implementation backing previews and tests.
    static var inMemoryValue: HouseholdClient {
        HouseholdClient(
            household: {
                @Dependency(\.homeyStore) var store
                return await store.loadHousehold()
            },
            members: {
                @Dependency(\.homeyStore) var store
                return await store.loadMembers()
            },
            currentMemberId: {
                @Dependency(\.homeyStore) var store
                return await store.currentMemberId
            }
        )
    }
}

extension DependencyValues {
    var householdClient: HouseholdClient {
        get { self[HouseholdClient.self] }
        set { self[HouseholdClient.self] = newValue }
    }
}

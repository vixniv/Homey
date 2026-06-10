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
    var generateInviteCode: @Sendable (_ householdId: UUID) async throws -> String
    var joinHousehold: @Sendable (_ code: String) async throws -> Void
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
            },
            generateInviteCode: { _ in "123456" },
            joinHousehold: { _ in }
        )
    }
}

extension DependencyValues {
    var householdClient: HouseholdClient {
        get { self[HouseholdClient.self] }
        set { self[HouseholdClient.self] = newValue }
    }
}

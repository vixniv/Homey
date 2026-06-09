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

extension HouseholdClient: DependencyKey {
    /// TEMPORARY: keeps the app compiling. A later task moves `liveValue`
    /// to Supabase/SupabaseHouseholdClient.swift and deletes it from here.
    static var liveValue: HouseholdClient { inMemoryValue }

    static var previewValue: HouseholdClient { inMemoryValue }
}

extension HouseholdClient {
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

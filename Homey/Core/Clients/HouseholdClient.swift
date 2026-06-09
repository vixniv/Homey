//
//  HouseholdClient.swift
//  Homey
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
struct HouseholdClient: Sendable {
    var household: @Sendable () async -> Household = { Household(id: UUID(), name: "") }
    var members: @Sendable () async -> [Member] = { [] }
    var currentMemberId: @Sendable () async -> UUID = { UUID() }
}

extension HouseholdClient: DependencyKey {
    static var liveValue: HouseholdClient {
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
    static var previewValue: HouseholdClient { liveValue }
}

extension DependencyValues {
    var householdClient: HouseholdClient {
        get { self[HouseholdClient.self] }
        set { self[HouseholdClient.self] = newValue }
    }
}

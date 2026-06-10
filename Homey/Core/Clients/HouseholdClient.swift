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

extension DependencyValues {
    var householdClient: HouseholdClient {
        get { self[HouseholdClient.self] }
        set { self[HouseholdClient.self] = newValue }
    }
}

//
//  SupabaseHouseholdClient.swift
//  Homey
//

import Dependencies
import Foundation
import Supabase

extension HouseholdClient: DependencyKey {
    static let liveValue = HouseholdClient(
        household: {
            let rows: [Household] = try await SupabaseClientProvider.shared
                .from("households")
                .select()
                .eq("id", value: DemoConfig.householdId.uuidString)
                .limit(1)
                .execute()
                .value
            guard let household = rows.first else { throw HomeyError.notFound }
            return household
        },
        members: {
            try await SupabaseClientProvider.shared
                .from("members")
                .select()
                .eq("household_id", value: DemoConfig.householdId.uuidString)
                .order("name")
                .execute()
                .value
        },
        currentMemberId: {
            DemoConfig.currentMemberId
        }
    )
}

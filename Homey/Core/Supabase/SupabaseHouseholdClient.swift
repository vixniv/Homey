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
            let session = try await SupabaseClientProvider.shared.auth.session
            let member: Member = try await SupabaseClientProvider.shared
                .from("members")
                .select()
                .eq("id", value: session.user.id.uuidString)
                .single()
                .execute()
                .value
            
            let rows: [Household] = try await SupabaseClientProvider.shared
                .from("households")
                .select()
                .eq("id", value: member.householdId.uuidString)
                .limit(1)
                .execute()
                .value
            guard let household = rows.first else { throw HomeyError.notFound }
            return household
        },
        members: {
            let session = try await SupabaseClientProvider.shared.auth.session
            let member: Member = try await SupabaseClientProvider.shared
                .from("members")
                .select()
                .eq("id", value: session.user.id.uuidString)
                .single()
                .execute()
                .value

            return try await SupabaseClientProvider.shared
                .from("members")
                .select()
                .eq("household_id", value: member.householdId.uuidString)
                .order("name")
                .execute()
                .value
        },
        currentMemberId: {
            if let session = try? await SupabaseClientProvider.shared.auth.session {
                return session.user.id
            }
            return DemoConfig.currentMemberId
        }
    )
}

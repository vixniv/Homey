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
        },
        generateInviteCode: { householdId in
            let code = String(format: "%06d", Int.random(in: 0...999999))
            let expiresAt = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            
            struct UpdateInvite: Encodable {
                let invite_code: String
                let invite_expires_at: String
            }
            
            try await SupabaseClientProvider.shared
                .from("households")
                .update(UpdateInvite(invite_code: code, invite_expires_at: expiresAt.ISO8601Format()))
                .eq("id", value: householdId.uuidString)
                .execute()
                
            return code
        },
        joinHousehold: { code in
            let session = try await SupabaseClientProvider.shared.auth.session
            let user = session.user
            
            let name = user.userMetadata["name"]?.stringValue ?? "Unknown"
            let emoji = user.userMetadata["emoji"]?.stringValue ?? "👤"
            
            // 1. Find household by valid invite code
            let now = Date().ISO8601Format()
            let rows: [Household] = try await SupabaseClientProvider.shared
                .from("households")
                .select()
                .eq("invite_code", value: code)
                .gte("invite_expires_at", value: now)
                .limit(1)
                .execute()
                .value
                
            guard let household = rows.first else { throw HomeyError.notFound }
            
            // 2. Insert member
            let newMember = Member(
                id: user.id,
                householdId: household.id,
                name: name,
                emoji: emoji,
                role: .member
            )
            try await SupabaseClientProvider.shared
                .from("members")
                .insert(newMember)
                .execute()
        }
    )
}

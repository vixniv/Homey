//
//  SupabaseChoreClient.swift
//  Homey
//

import Dependencies
import Foundation
import Supabase

extension ChoreClient: DependencyKey {
    static let liveValue = ChoreClient(
        allChores: {
            try await SupabaseClientProvider.shared
                .from("chores")
                .select()
                .eq("household_id", value: DemoConfig.householdId.uuidString)
                .order("due_date")
                .execute()
                .value
        },
        completions: {
            try await SupabaseClientProvider.shared
                .from("chore_completions")
                .select()
                .execute()
                .value
        },
        create: { chore in
            _ = try await SupabaseClientProvider.shared
                .from("chores")
                .insert(chore)
                .execute()
        },
        grab: { choreId, memberId in
            _ = try await SupabaseClientProvider.shared
                .from("chores")
                .update(GrabPatch(assigneeId: memberId.uuidString, status: "in_progress"))
                .eq("id", value: choreId.uuidString)
                .execute()
        },
        finish: { choreId, memberId, date in
            _ = try await SupabaseClientProvider.shared
                .from("chores")
                .update(StatusPatch(status: "done"))
                .eq("id", value: choreId.uuidString)
                .execute()
            let completion = ChoreCompletion(
                id: UUID(),
                choreId: choreId,
                completedBy: memberId,
                completedAt: date
            )
            _ = try await SupabaseClientProvider.shared
                .from("chore_completions")
                .insert(completion)
                .execute()
        },
        delete: { choreId in
            _ = try await SupabaseClientProvider.shared
                .from("chores")
                .delete()
                .eq("id", value: choreId.uuidString)
                .execute()
        },
        update: { chore in
            _ = try await SupabaseClientProvider.shared
                .from("chores")
                .update(chore)
                .eq("id", value: chore.id.uuidString)
                .execute()
        },
        allOccurrences: {
            try await SupabaseClientProvider.shared
                .from("chore_occurrences")
                .select()
                .execute()
                .value
        },
        upsertOccurrence: { occurrence in
            _ = try await SupabaseClientProvider.shared
                .from("chore_occurrences")
                .upsert(occurrence, onConflict: "chore_id,occurrence_date")
                .execute()
        }
    )
}

// MARK: - Partial-update payloads
//
// PostgREST's `.update(_:)` takes `some Encodable`. Passing a plain Swift
// dictionary literal (inferred as `[String: String]`) faults inside the SDK's
// encoder (EXC_BAD_ACCESS), so partial updates go through typed structs whose
// CodingKeys map to the snake_case column names.

private struct GrabPatch: Encodable {
    let assigneeId: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case assigneeId = "assignee_id"
        case status
    }
}

private struct StatusPatch: Encodable {
    let status: String
}

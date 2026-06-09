//
//  SupabaseConfig.swift
//  Homey
//
//  Publishable (anon) key is safe to embed in the client — access is gated by RLS.
//  For real secrets use an xcconfig (see README). Demo identifiers must match
//  supabase/migrations/0002_seed_demo.sql exactly.
//

import Foundation

enum SupabaseConfig {
    static let url = URL(string: "https://dhnfjtdghqrdmlcfhixx.supabase.co")!
    static let anonKey = "sb_publishable_n5j8J9NgKod-FLEddIHP1A_8HjMnyNI"
}

enum DemoConfig {
    static let householdId = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    static let currentMemberId = UUID(uuidString: "44444444-4444-4444-4444-444444444444")! // Ana
}

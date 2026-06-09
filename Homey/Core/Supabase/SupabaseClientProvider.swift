//
//  SupabaseClientProvider.swift
//  Homey
//

import Foundation
import Supabase

enum SupabaseClientProvider {
    static let shared = SupabaseClient(
        supabaseURL: SupabaseConfig.url,
        supabaseKey: SupabaseConfig.anonKey
    )
}

enum HomeyError: LocalizedError {
    case notFound

    var errorDescription: String? {
        switch self {
        case .notFound: return "The requested record was not found."
        }
    }
}

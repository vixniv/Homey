//
//  RootViewModel.swift
//  Homey
//

import Foundation
import Observation
import Supabase

@MainActor
@Observable
final class RootViewModel {
    enum Route {
        case auth
        case onboarding
        case signedIn
    }

    var route: Route = .auth

    init() {
        Task {
            for await state in SupabaseClientProvider.shared.auth.authStateChanges {
                if state.event == .initialSession || state.event == .signedIn {
                    guard let userId = state.session?.user.id else {
                        self.route = .auth
                        continue
                    }
                    
                    do {
                        let _: Member = try await SupabaseClientProvider.shared
                            .from("members")
                            .select()
                            .eq("id", value: userId.uuidString)
                            .single()
                            .execute()
                            .value
                        
                        self.route = .signedIn
                    } catch {
                        self.route = .onboarding
                    }
                } else if state.event == .signedOut {
                    self.route = .auth
                }
            }
        }
    }

    /// Demo entry: no real auth user yet — just enter the app pointed at the
    /// shared demo household (accessed via the publishable key + anon RLS).
    func signInDemo() {
        route = .signedIn
    }

    func completeOnboarding() {
        route = .signedIn
    }

    func signOut() {
        Task {
            try? await SupabaseClientProvider.shared.auth.signOut()
            self.route = .auth
        }
    }
}

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
        case signedIn
    }

    var route: Route = .auth

    init() {
        Task {
            for await state in SupabaseClientProvider.shared.auth.authStateChanges {
                if state.event == .initialSession {
                    self.route = state.session != nil ? .signedIn : .auth
                } else if state.event == .signedIn {
                    self.route = .signedIn
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

    func signOut() {
        Task {
            try? await SupabaseClientProvider.shared.auth.signOut()
            self.route = .auth
        }
    }
}

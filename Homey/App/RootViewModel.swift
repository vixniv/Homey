//
//  RootViewModel.swift
//  Homey
//

import Foundation
import Observation

@MainActor
@Observable
final class RootViewModel {
    enum Route {
        case auth
        case signedIn
    }

    var route: Route = .auth

    /// Demo entry: no real auth user yet — just enter the app pointed at the
    /// shared demo household (accessed via the publishable key + anon RLS).
    func signInDemo() {
        route = .signedIn
    }

    func signOut() {
        route = .auth
    }
}

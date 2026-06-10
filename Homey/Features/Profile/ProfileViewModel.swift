import Dependencies
import Foundation
import Observation
import Supabase
import SwiftUI

@MainActor
@Observable
final class ProfileViewModel {
    @ObservationIgnored @Dependency(\.householdStore) private var store

    var userEmail: String = ""

    var userName: String {
        guard let currentId = store.currentMemberId else { return "Loading..." }
        return store.members.first { $0.id == currentId }?.name ?? "Unknown"
    }
    
    var totalTasks: Int {
        guard let currentId = store.currentMemberId else { return 0 }
        return store.completions.filter { $0.completedBy == currentId }.count
    }

    var daysStreak: Int {
        return 0 // Placeholder
    }

    var minutesSpent: Int {
        return totalTasks * 15 // Placeholder
    }

    var members: [HouseholdMember] {
        store.members.map { member in
            let initials = String(member.name.prefix(2)).uppercased()
            return HouseholdMember(initials: initials, color: .blue)
        }
    }

    func load() async {
        if let session = try? await SupabaseClientProvider.shared.auth.session {
            self.userEmail = session.user.email ?? ""
        }
    }
}

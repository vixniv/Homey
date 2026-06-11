import Dependencies
import Foundation
import Observation
import Supabase
import SwiftUI

@MainActor
@Observable
final class ProfileViewModel {
    @ObservationIgnored @Dependency(\.householdStore) private var store
    @ObservationIgnored @Dependency(\.date.now) private var now

    private let calendar = Calendar(identifier: .gregorian)

    var userEmail: String = ""

    var userName: String {
        guard let currentId = store.currentMemberId else { return "Loading..." }
        return store.members.first { $0.id == currentId }?.name ?? "Unknown"
    }

    var userEmoji: String {
        guard let currentId = store.currentMemberId else { return "🙂" }
        return store.members.first { $0.id == currentId }?.emoji ?? "🙂"
    }

    /// All-time tasks completed by the current member.
    var totalTasks: Int {
        guard let currentId = store.currentMemberId else { return 0 }
        return store.completions.filter { $0.completedBy == currentId }.count
    }

    /// Consecutive days — ending today, or yesterday if nothing is done yet today —
    /// on which the current member completed at least one task.
    var daysStreak: Int {
        guard let currentId = store.currentMemberId else { return 0 }
        let days = Set(
            store.completions
                .filter { $0.completedBy == currentId }
                .map { calendar.startOfDay(for: $0.completedAt) }
        )
        guard !days.isEmpty else { return 0 }

        var day = calendar.startOfDay(for: now)
        if !days.contains(day) {
            day = calendar.date(byAdding: .day, value: -1, to: day) ?? day
            guard days.contains(day) else { return 0 }
        }
        var streak = 0
        while days.contains(day) {
            streak += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = prev
        }
        return streak
    }

    /// Tasks the current member completed in the current Mon–Sun week.
    var tasksThisWeek: Int {
        guard let currentId = store.currentMemberId else { return 0 }
        let start = weekStart(for: now)
        let end = calendar.date(byAdding: .day, value: 7, to: start) ?? start
        return store.completions.filter {
            $0.completedBy == currentId && $0.completedAt >= start && $0.completedAt < end
        }.count
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

    /// Monday 00:00 of the week containing `date` (matches Home/Statistics).
    private func weekStart(for date: Date) -> Date {
        let startOfDay = calendar.startOfDay(for: date)
        let weekday = calendar.component(.weekday, from: startOfDay) // 1=Sun…7=Sat
        let daysFromMonday = (weekday + 5) % 7
        return calendar.date(byAdding: .day, value: -daysFromMonday, to: startOfDay) ?? startOfDay
    }
}

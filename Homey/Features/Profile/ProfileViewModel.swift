import Dependencies
import Foundation
import Observation

@MainActor
@Observable
final class ProfileViewModel {
    @ObservationIgnored @Dependency(\.householdStore) private var store

    // Sample data
    let totalTasks: Int = 56
    let daysStreak: Int = 365
    let minutesSpent: Int = 1023
    
    var userName: String {
        let name = store.members.first(where: { $0.id == store.currentMemberId })?.name ?? store.householdName
        return name.isEmpty ? "Unknown" : name
    }
    
    var userEmail: String {
        "\(userName.lowercased())@gmail.com"
    }
    
    var members: [Member] {
        store.members
    }
    
    func signOut() {
        // sign out action
    }
}

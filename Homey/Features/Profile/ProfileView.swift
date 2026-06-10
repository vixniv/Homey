import SwiftUI
import Supabase
import Dependencies

// MARK: - Models

struct HouseholdMember: Identifiable {
    let id = UUID()
    let initials: String
    let color: Color
}

// MARK: - Profile View

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

struct ProfileView: View {
    @Environment(RootViewModel.self) private var rootModel
    @State private var viewModel = ProfileViewModel()
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: Avatar + Name
                avatarSection

                // MARK: Stats Row
                statsRow

                // MARK: Household Section
                householdSection

                // MARK: Account & Settings
                accountSection

                // MARK: Sign Out
                signOutButton

                Spacer(minLength: 32)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
        .background(Color(.systemGroupedBackground))
        .navigationToolbar(
            title: "Profile"
        )
        .task {
            await viewModel.load()
        }
    }
    
    // MARK: - Avatar Section
    
    private var avatarSection: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                // Avatar circle
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 90, height: 90)
                    .overlay(
                        Text(String(viewModel.userName.prefix(2)).uppercased())
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.blue)
                    )
                
                // Camera badge
                Circle()
                    .fill(Color(.systemBackground))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.primary)
                    )
                    .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                    .offset(x: 4, y: 4)
            }
            
            Text(viewModel.userName)
                .font(.system(size: 20, weight: .bold))
            
            Text(viewModel.userEmail)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Stats Row
    
    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(value: "\(viewModel.totalTasks)", label: "Total Tasks")
            StatCard(value: "🔥 \(viewModel.daysStreak)", label: "Days Streak")
            StatCard(value: "\(viewModel.minutesSpent)", label: "Minutes Spent")
        }
    }
    
    // MARK: - Household Section
    
    private var householdSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Household")
            
            VStack(spacing: 0) {
                // Manage Household Members
                NavigationLink(destination: ManageMemberView()) {
                    HStack(spacing: 14) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                            .frame(width: 28)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Manage Household Member")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                            
                            // Member avatars
                            HStack(spacing: 4) {
                                ForEach(viewModel.members) { member in
                                    MemberBadge(initials: member.initials)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                
                Divider().padding(.leading, 58)
                
                // Statistics
                NavigationLink(destination: StatisticsView()) {
                    SettingsRow(
                        icon: "chart.bar.fill",
                        iconColor: .blue,
                        title: "Statistic",
                        subtitle: "Household task breakdown"
                    )
                }
                
                Divider().padding(.leading, 58)
                
                // Notification
                NavigationLink(destination: NotificationView()) {
                    SettingsRow(
                        icon: "bell.fill",
                        iconColor: .blue,
                        title: "Notification",
                        subtitle: "Reminders & alerts"
                    )
                }
            }
            .background(Color(.statisticBg))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }
    
    // MARK: - Account & Settings
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Account & Settings")
            
            NavigationLink(destination: Text("Change Password")) {
                SettingsRow(
                    icon: "lock.fill",
                    iconColor: .blue,
                    title: "Change Password",
                    subtitle: nil
                )
            }
            .background(Color(.statisticBg))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }
    
    // MARK: - Sign Out
    
    private var signOutButton: some View {
        Button {
            rootModel.signOut()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18))
                    .foregroundColor(.red)
                    .frame(width: 28)
                
                Text("Sign Out")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.red)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(.statisticBg))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.statisticBg))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.secondary)
            .textCase(nil)
    }
}

struct MemberBadge: View {
    let initials: String
    
    var body: some View {
        Text(initials)
            .font(.system(size: 9, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 26, height: 22)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(iconColor)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                
                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, subtitle != nil ? 12 : 16)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProfileView()
            .environment(RootViewModel())
    }
}

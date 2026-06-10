//
//  ManageMemberView.swift
//  Homey
//
//  Created by Yoram on 05/06/26.
//

import SwiftUI
import Dependencies

// MARK: - Model

struct HouseholdManageMember: Identifiable {
    let id: UUID
    let name: String

    var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
}

@MainActor
@Observable
final class ManageMemberViewModel {
    @ObservationIgnored @Dependency(\.householdStore) private var store

    var members: [HouseholdManageMember] {
        store.members.map { HouseholdManageMember(id: $0.id, name: $0.name) }
    }
}

// MARK: - Main View

struct ManageMemberView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = ManageMemberViewModel()

    @State private var swipedMemberID: UUID? = nil

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Member list
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.members) { member in
                            MemberRowView(
                                member: member,
                                isSwipedOpen: swipedMemberID == member.id,
                                onSwipe: {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                        swipedMemberID = swipedMemberID == member.id ? nil : member.id
                                    }
                                },
                                onDelete: {
                                    // TODO: Implement actual deletion logic with Supabase
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        swipedMemberID = nil
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
                .simultaneousGesture(
                    TapGesture().onEnded {
                        if swipedMemberID != nil {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                swipedMemberID = nil
                            }
                        }
                    }
                )

                Divider()
                    .opacity(0)

                // Invite buttons
                VStack(spacing: 12) {
                    Button(action: {}) {
                        Text("Invite via QR code")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(hex: "#4AAEE8"))
                            .clipShape(Capsule())
                    }

                    Button(action: {}) {
                        Text("Invite via link")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(UIColor.label))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .background(Color(UIColor.systemGroupedBackground))
            }
        }
        .navigationTitle("Manage Household Member")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Member Row View

struct MemberRowView: View {
    let member: HouseholdManageMember
    let isSwipedOpen: Bool
    let onSwipe: () -> Void
    let onDelete: () -> Void

    private let deleteButtonWidth: CGFloat = 64

    var body: some View {
        ZStack(alignment: .trailing) {
            // Delete button revealed behind the row
            if isSwipedOpen {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: deleteButtonWidth, height: 56)
                        .background(Color(hex: "#E8547A"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .transition(.opacity)
            }

            // The member card
            HStack(spacing: 14) {
                AvatarView(initials: member.initials)

                Text(member.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(UIColor.label))

                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .offset(x: isSwipedOpen ? -(deleteButtonWidth + 8) : 0)
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width < -40 || value.translation.width > 40 {
                            onSwipe()
                        }
                    }
            )
        }
        .clipped()
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isSwipedOpen)
    }
}

// MARK: - Avatar View

struct AvatarView: View {
    let initials: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "#4AAEE8"))
                .frame(width: 38, height: 38)

            Text(initials)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

#Preview {
    ManageMemberView()
}

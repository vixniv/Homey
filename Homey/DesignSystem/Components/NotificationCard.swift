//
//  NotificationCard.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 06/06/26.
//

import SwiftUI

enum NotificationType {
    case choreAssigned
    case upcomingChore
    case reminder

    var backgroundColor: Color {
        switch self {
        case .choreAssigned: return Color.taskBlue
        case .upcomingChore: return Color.taskYellow
        case .reminder:      return Color.taskRed
        }
    }

    var dotColor: Color {
        switch self {
        case .choreAssigned: return Color.appPrimary
        case .upcomingChore: return Color.badgeYellow
        case .reminder:      return Color.textRed
        }
    }

    var titleTextColor: Color {
        switch self {
        case .choreAssigned: return Color.blue
        case .upcomingChore: return Color.orange
        case .reminder:      return Color.pink
        }
    }
    
    var icon: Image {
        switch self {
        case .choreAssigned: return Image(.choreAssigned)
        case .upcomingChore: return Image(.upcomingTask)
        case .reminder:      return Image(.bell)
        }
    }
}

struct NotificationCard: View {
    var title: String
    var subtitle: String
    var detail: String
    var timeAgo: String
    var type: NotificationType
    var isRead: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            type.icon
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)

                Text(subtitle)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(type.titleTextColor)

                Text(detail)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(timeAgo)
                    .font(.caption2)
                    .foregroundStyle(Color.secondary)

                if !isRead {
                    Circle()
                        .fill(type.dotColor)
                        .frame(width: 10, height: 10)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            isRead
                ? Color(.systemBackground)
                : type.backgroundColor
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 8) {
            NotificationCard(
                title: "Chore assigned to you",
                subtitle: "Clean the bathroom",
                detail: "Due on 28 / 05 / 2026 at 08.00 P.M.",
                timeAgo: "2 min ago",
                type: .choreAssigned,
                isRead: true
            )

            NotificationCard(
                title: "Upcoming chore",
                subtitle: "Sweeping floor",
                detail: "Due today at 08.00 P.M.",
                timeAgo: "2 min ago",
                type: .upcomingChore,
                isRead: true
            )

            NotificationCard(
                title: "Reminder",
                subtitle: "2 chores are due at 8 P.M.",
                detail: "Don't forget to do it",
                timeAgo: "2 min ago",
                type: .reminder,
                isRead: true
            )

            // Belum dibaca — ada warna background + dot
            NotificationCard(
                title: "Chore assigned to you",
                subtitle: "Clean the bathroom",
                detail: "Due on 28 / 05 / 2026 at 08.00 P.M.",
                timeAgo: "2 min ago",
                type: .choreAssigned,
                isRead: false
            )

            NotificationCard(
                title: "Upcoming chore",
                subtitle: "Sweeping floor",
                detail: "Due today at 08.00 P.M.",
                timeAgo: "2 min ago",
                type: .upcomingChore,
                isRead: false
            )

            NotificationCard(
                title: "Reminder",
                subtitle: "2 chores are due at 8 P.M.",
                detail: "Don't forget to do it",
                timeAgo: "2 min ago",
                type: .reminder,
                isRead: false
            )
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}

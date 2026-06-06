//
//  NotificationView.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 06/06/26.
//

import SwiftUI

struct NotificationView: View {
    @State var selected = 0
    
    let notifications: [NotificationItem] = [
        NotificationItem(title: "Chore assigned to you", subtitle: "Clean the bathroom", detail: "Due on 28/05/2026 at 08.00 P.M.", timeAgo: "2 min ago", type: .choreAssigned, isRead: false),
        NotificationItem(title: "Upcoming chore", subtitle: "Sweeping floor", detail: "Due today at 08.00 P.M.", timeAgo: "5 min ago", type: .upcomingChore, isRead: true),
        NotificationItem(title: "Reminder", subtitle: "2 chores are due at 8 P.M.", detail: "Don't forget to do it", timeAgo: "10 min ago", type: .reminder, isRead: false)
    ]
    
    var filteredNotifications: [NotificationItem] {
        if selected == 1 {
            return notifications.filter { !$0.isRead }
        }
        return notifications
    }
    
    var body: some View {
        ScrollView{
            SegmentedControl(
                selectedIndex: $selected,
                options: ["All", "Unread"]
            )
            .padding()
            
            VStack(spacing: 8) {
                ForEach(filteredNotifications) { item in NotificationCard(
                    title: item.title,
                    subtitle: item.subtitle,
                    detail: item.detail,
                    timeAgo: item.timeAgo,
                    type: item.type,
                    isRead: item.isRead
                    )
                }
            }
            .padding(.horizontal)
        }
        .navigationToolbar(title: "Notification")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: NotificationSettings()) {
                    Image(systemName: "gear")
                        .imageScale(.medium)
                        .symbolRenderingMode(.hierarchical)
                }
            }
        }
        
    }
    struct NotificationItem: Identifiable {
        let id = UUID()
        var title: String
        var subtitle: String
        var detail: String
        var timeAgo: String
        var type: NotificationType
        var isRead: Bool
    }
}

#Preview {
    NotificationView()
}

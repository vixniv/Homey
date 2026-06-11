//
//  NotificationView.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 06/06/26.
//

import SwiftUI

struct NotificationView: View {
    @State var selected = 0
    private var store = NotificationStore.shared
    
    var filteredNotifications: [NotificationItem] {
        selected == 1 ? store.items.filter { !$0.isRead } : store.items
    }
    
    var body: some View {
        ScrollView {
            Picker("Filter", selection: $selected) {
                Text("All").tag(0)
                Text("Unread").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            
            if store.items.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("No notifications yet")
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 80)
            } else {
                VStack(spacing: 8) {
                    ForEach(filteredNotifications) { item in
                        Button {
                            NotificationStore.shared.markAsRead(id: item.id)
                        } label: {
                            NotificationCard(
                            title: item.title,
                            subtitle: item.subtitle,
                            detail: item.detail,
                            timeAgo: item.timeAgo,
                            type: item.type,
                            isRead: item.isRead
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
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
}

#Preview {
    NotificationView()
}

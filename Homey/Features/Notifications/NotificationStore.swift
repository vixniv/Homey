//
//  NotificationStore.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 10/06/26.
//

import Foundation
import Observation

struct NotificationItem: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var detail: String
    var timeAgo: String
    var type: NotificationType
    var isRead: Bool
    var createdAt: Date = Date()
}

@Observable
final class NotificationStore {
    static let shared = NotificationStore()
    private init() {}
    
    var items: [NotificationItem] = []
    
    var unreadCount: Int {
        items.filter { !$0.isRead }.count
    }
    
    func add(_ item: NotificationItem) {
        items.insert(item, at: 0)
    }
    
    func markAsRead(id: UUID) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].isRead = true
        }
    }
}

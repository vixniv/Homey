//
//  NotificationManager.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 10/06/26.
//

import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, _ in
            print(granted ? "✅ Notification permission granted" : "❌ Notification permission denied")
        }
    }
    
    func sendTaskCreatedNotification(taskTitle: String, assigneeName: String?, creatorName: String?) {
        let creator = creatorName ?? "Someone"
        let title = "\(creator) Needs Help! 🏠"
        
        let body = assigneeName != nil
        ? "\(creator) assigned \"\(taskTitle)\" to \(assigneeName!)"
        : "\(creator) added \"\(taskTitle)\" to the list"
        
        let type: NotificationType = assigneeName != nil ? .choreAssigned : .upcomingChore
        
        NotificationStore.shared.add(NotificationItem(
            title: title,
            subtitle: taskTitle,
            detail: body,
            timeAgo: "Just now",
            type: type,
            isRead: false
        ))
        sendSystem(title: title, body: body, after: 0.5)
    }
    func scheduleUpcomingNotification(taskTitle: String, dueDate: Date) {
        let title = "Upcoming Chore ⏰"
        let body = "\"\(taskTitle)\" is due now!"
        
        let secondsUntilDue = dueDate.timeIntervalSinceNow
        guard secondsUntilDue > 0 else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy 'at' hh:mm a"
        
        NotificationStore.shared.add(NotificationItem(
            title: title,
            subtitle: taskTitle,
            detail: "Due on \(formatter.string(from: dueDate))",
            timeAgo: "Upcoming",
            type: .upcomingChore,
            isRead: false
        ))
        
        sendSystem(title: title, body: body, after: secondsUntilDue)
    }
        
    func scheduleReminderNotification(taskTitle: String, dueDate: Date) {
        let twoHoursBefore = dueDate.timeIntervalSinceNow - (2 * 60 * 60)
        let secondsUntilDue = dueDate.timeIntervalSinceNow
        
        guard secondsUntilDue > 0 else { return }
        
        let title = "Reminder 🔔"
        let detail: String
        let body: String
        
        if twoHoursBefore > 0 {
            body = "\"\(taskTitle)\" is due in 2 hours. Don't forget!"
            detail = "Due in 2 hours"
        } else {
            let minutesLeft = Int(secondsUntilDue / 60)
            body = "\"\(taskTitle)\" is due in \(minutesLeft) minutes. Hurry up!"
            detail = "Due in \(minutesLeft) minutes"
        }
        
        NotificationStore.shared.add(NotificationItem(
            title: title,
            subtitle: taskTitle,
            detail: detail,
            timeAgo: "Reminder",
            type: .reminder,
            isRead: false
        ))
        sendSystem(title: title, body: body, after: max(twoHoursBefore, 0.5))
    }
    private func sendSystem(title: String, body: String, after seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(seconds, 0.5), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
        UNUserNotificationCenter.current().add(request) { error in
            if let error { print("❌ \(error)") }
        }
    }
}

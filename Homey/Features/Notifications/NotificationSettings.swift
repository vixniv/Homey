//
//  NotificationSettings.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 07/06/26.
//

import SwiftUI

struct NotificationSettings: View {
    @State private var reminderOn = true
    @State private var alertsOn = true
    @State private var soundOn = false
    var body: some View {
        List {
            ToggleFeature(
                title: "Reminder",
                subtitle: "Get gentle reminders before a chore is due.",
                isOn: $reminderOn
            )
            ToggleFeature(
                title: "Alerts",
                subtitle: "Get notified when a chore is assigned or overdue.",
                isOn: $alertsOn
            )
        }
        .navigationTitle("Notification Settings")
    }
}

#Preview {
    NotificationSettings()
}

//
//  TaskFormViewModel.swift
//  Homey
//

import Dependencies
import Foundation
import Observation

@MainActor
@Observable
final class TaskFormViewModel {
    enum Mode: Equatable {
        case create
        case edit(Chore)
    }

    @ObservationIgnored @Dependency(\.householdStore) private var store

    let mode: Mode
    var title = ""
    var date = Date()
    var time = Date()
    var notes = ""
    var assigneeId: UUID?
    var recurrence: Recurrence = .once
    var recurrenceDays: Set<Int> = []      // 0=Sun … 6=Sat

    init(mode: Mode = .create) {
        self.mode = mode
        if case let .edit(chore) = mode {
            title = chore.title
            notes = chore.notes
            assigneeId = chore.assigneeId
            date = chore.dueDate
            time = chore.dueDate
            recurrence = chore.recurrence
            recurrenceDays = Set(chore.recurrenceDays)
        }
    }

    var members: [Member] { store.members }

    var errorMessage: String? {
        get { store.errorMessage }
        set { store.errorMessage = newValue }
    }

    var isEditing: Bool { if case .edit = mode { return true }; return false }
    var navTitle: String { isEditing ? "Edit Task" : "Add Task" }
    var ctaTitle: String { isEditing ? "Save" : "Create Task" }

    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        if recurrence == .weekly && recurrenceDays.isEmpty { return false }
        return true
    }

    func load() async {
        if store.members.isEmpty { await store.load() }
    }

    func save() async -> Bool {
        guard canSave else { return false }
        let due = combine(date: date, time: time)
        let days = recurrence == .weekly ? recurrenceDays.sorted() : []

        switch mode {
        case .create:
            guard let householdId = store.householdId ?? store.members.first?.householdId else { return false }
            let chore = Chore(
                id: UUID(),
                householdId: householdId,
                title: title,
                notes: notes,
                assigneeId: assigneeId,
                dueDate: due,
                recurrence: recurrence,
                recurrenceDays: days,
                status: assigneeId == nil ? .available : .inProgress
            )
            await store.create(chore)
            let assigneeName = members.first(where: { $0.id == assigneeId })?.name
            let creatorName = members.first(where: { $0.id == store.currentMemberId })?.name

            NotificationManager.shared.sendTaskCreatedNotification(
                taskTitle: title,
                assigneeName: assigneeName,
                creatorName: creatorName
            )
            if assigneeId == nil {
                NotificationManager.shared.scheduleUpcomingNotification(
                    taskTitle: title,
                    dueDate: due
                )
            }
            NotificationManager.shared.scheduleReminderNotification(
                taskTitle: title,
                dueDate: due
            )
            return true

        case let .edit(original):
            var updated = original
            updated.title = title
            updated.notes = notes
            updated.assigneeId = assigneeId
            updated.dueDate = due
            updated.recurrence = recurrence
            updated.recurrenceDays = days
            await store.update(updated)
        }

        return store.errorMessage == nil
    }

    private func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let day = calendar.dateComponents([.year, .month, .day], from: date)
        let clock = calendar.dateComponents([.hour, .minute], from: time)
        var c = DateComponents()
        c.year = day.year; c.month = day.month; c.day = day.day; c.hour = clock.hour; c.minute = clock.minute
        return calendar.date(from: c) ?? date
    }
}

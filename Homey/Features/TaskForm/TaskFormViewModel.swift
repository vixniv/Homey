//
//  TaskFormViewModel.swift
//  Homey

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

    init(mode: Mode = .create) {
        self.mode = mode
        if case let .edit(chore) = mode {
            title = chore.title
            notes = chore.notes
            assigneeId = chore.assigneeId
            date = chore.dueDate
            time = chore.dueDate
        }
    }

    var members: [Member] { store.members }

    var errorMessage: String? {
        get { store.errorMessage }
        set { store.errorMessage = newValue }
    }

    var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    var navTitle: String { isEditing ? "Edit Task" : "Add Task" }
    var ctaTitle: String { isEditing ? "Save" : "Create Task" }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func load() async {
        if store.members.isEmpty { await store.load() }
    }

    /// Returns true on success so the view can dismiss.
    func save() async -> Bool {
        guard canSave else { return false }
        let due = combine(date: date, time: time)

        switch mode {
        case .create:
            guard let householdId = store.householdId ?? store.members.first?.householdId else {
                return false
            }
            let chore = Chore(
                id: UUID(),
                householdId: householdId,
                title: title,
                notes: notes,
                assigneeId: assigneeId,
                dueDate: due,
                recurrence: .once,
                status: assigneeId == nil ? .available : .inProgress
            )
            await store.create(chore)

        case let .edit(original):
            var updated = original
            updated.title = title
            updated.notes = notes
            updated.assigneeId = assigneeId
            updated.dueDate = due
            // status and recurrence are preserved intentionally.
            await store.update(updated)
        }

        return store.errorMessage == nil
    }

    private func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let day = calendar.dateComponents([.year, .month, .day], from: date)
        let clock = calendar.dateComponents([.hour, .minute], from: time)
        var components = DateComponents()
        components.year = day.year
        components.month = day.month
        components.day = day.day
        components.hour = clock.hour
        components.minute = clock.minute
        return calendar.date(from: components) ?? date
    }
}

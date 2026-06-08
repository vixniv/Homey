//
//  AddTaskViewModel.swift
//  Homey
//

import Dependencies
import Foundation
import Observation

@MainActor
@Observable
final class AddTaskViewModel {
    @ObservationIgnored @Dependency(\.choreClient) private var choreClient
    @ObservationIgnored @Dependency(\.householdClient) private var householdClient

    var title = ""
    var date = Date()
    var time = Date()
    var notes = ""
    var assigneeId: UUID?
    var members: [Member] = []

    private var householdId: UUID?

    var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func load() async {
        members = await householdClient.members()
        householdId = await householdClient.household().id
    }

    func create() async {
        guard let householdId else { return }
        let chore = Chore(
            id: UUID(),
            householdId: householdId,
            title: title,
            notes: notes,
            assigneeId: assigneeId,
            dueDate: combine(date: date, time: time),
            recurrence: .once,
            status: assigneeId == nil ? .available : .inProgress
        )
        await choreClient.create(chore)
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

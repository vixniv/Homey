//
//  Chore.swift
//  Homey
//

import Foundation

struct Chore: Identifiable, Hashable, Sendable, Codable {
    let id: UUID
    let householdId: UUID
    var title: String
    var notes: String = ""
    var assigneeId: UUID?
    var dueDate: Date
    var recurrence: Recurrence = .once
    var status: ChoreStatus = .available
}

enum ChoreStatus: String, Sendable, Codable {
    case available
    case assigned
    case inProgress
    case done
}

enum Recurrence: Hashable, Sendable, Codable {
    case once
    case daily
    case weekly([Weekday])
}

enum Weekday: Int, Sendable, Codable, CaseIterable, Hashable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

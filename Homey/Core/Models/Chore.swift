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

    enum CodingKeys: String, CodingKey {
        case id
        case householdId = "household_id"
        case title, notes
        case assigneeId = "assignee_id"
        case dueDate = "due_date"
        case recurrence, status
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(householdId, forKey: .householdId)
        try container.encode(title, forKey: .title)
        try container.encode(notes, forKey: .notes)
        try container.encode(assigneeId, forKey: .assigneeId)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(recurrence, forKey: .recurrence)
        try container.encode(status, forKey: .status)
    }
}

enum ChoreStatus: String, Sendable, Codable {
    case available
    case inProgress = "in_progress"
    case done
}

enum Recurrence: String, Sendable, Codable {
    case once
    case daily
    case weekly
}

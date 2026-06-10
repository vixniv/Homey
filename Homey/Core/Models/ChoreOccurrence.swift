//
//  ChoreOccurrence.swift
//  Homey
//
//  Per-day override for a recurring chore. A row exists only once an occurrence
//  is grabbed/finished; absent = available + the template's default assignee.
//

import Foundation

struct ChoreOccurrence: Identifiable, Hashable, Sendable, Codable {
    let id: UUID
    let choreId: UUID
    var occurrenceDate: String   // day key "yyyy-MM-dd" (Postgres `date` column)
    var assigneeId: UUID?
    var status: ChoreStatus

    enum CodingKeys: String, CodingKey {
        case id
        case choreId = "chore_id"
        case occurrenceDate = "occurrence_date"
        case assigneeId = "assignee_id"
        case status
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(choreId, forKey: .choreId)
        try container.encode(occurrenceDate, forKey: .occurrenceDate)
        try container.encode(assigneeId, forKey: .assigneeId)
        try container.encode(status, forKey: .status)
    }
}

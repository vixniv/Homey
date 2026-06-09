//
//  ChoreCompletion.swift
//  Homey
//

import Foundation

struct ChoreCompletion: Identifiable, Hashable, Sendable, Codable {
    let id: UUID
    let choreId: UUID
    let completedBy: UUID
    var completedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case choreId = "chore_id"
        case completedBy = "completed_by"
        case completedAt = "completed_at"
    }
}

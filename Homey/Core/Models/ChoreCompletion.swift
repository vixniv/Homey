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
    var photoData: Data?
}

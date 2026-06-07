//
//  Household.swift
//  Homey
//

import Foundation

struct Household: Identifiable, Hashable, Sendable, Codable {
    let id: UUID
    var name: String
    var memberIds: [UUID]
}

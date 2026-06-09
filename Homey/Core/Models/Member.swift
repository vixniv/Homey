//
//  Member.swift
//  Homey
//

import Foundation

struct Member: Identifiable, Hashable, Sendable, Codable {
    let id: UUID
    var householdId: UUID
    var name: String
    var emoji: String
    var role: MemberRole = .member

    enum CodingKeys: String, CodingKey {
        case id
        case householdId = "household_id"
        case name, emoji, role
    }
}

enum MemberRole: String, Sendable, Codable {
    case admin
    case member
}

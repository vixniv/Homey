//
//  Household.swift
//  Homey
//

import Foundation

struct Household: Identifiable, Hashable, Sendable, Codable {
    let id: UUID
    var name: String
    var inviteCode: String?
    var inviteExpiresAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, name
        case inviteCode = "invite_code"
        case inviteExpiresAt = "invite_expires_at"
    }
}

//
//  Member.swift
//  Homey
//

import Foundation

struct Member: Identifiable, Hashable, Sendable, Codable {
    let id: UUID
    var name: String
    var emoji: String
    var role: MemberRole = .member
}

enum MemberRole: String, Sendable, Codable {
    case admin
    case member
}

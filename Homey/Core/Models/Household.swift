//
//  Household.swift
//  Homey
//

import Foundation

struct Household: Identifiable, Hashable, Sendable, Codable {
    let id: UUID
    var name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

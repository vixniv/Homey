//
//  MockMembers.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import Foundation

struct HouseholdMemberModel : Identifiable {
    let id: UUID = UUID()
    var nickname: String
    var imageURL: URL?
    let numberOfTasks: Int = Int.random(in: 1...8)
    
    // mock members
    static let mockMembers: [HouseholdMemberModel] = [
        HouseholdMemberModel(nickname: "Ana"),
        HouseholdMemberModel(nickname: "Adi"),
        HouseholdMemberModel(nickname: "Ama"),
        HouseholdMemberModel(nickname: "Dad")
    ]
    
    // mock user
    static var mockUser: HouseholdMemberModel {
        mockMembers[0]
    }
}

//
//  MockMembers.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import Foundation

struct MockMember: MemberAvatarProtocol {
    let id: UUID = UUID()
    var nickname: String
    var imageURL: URL?
    func getNumberOfTask() -> Int {
        Int.random(in: 1...8)
    }
    
    // mock members
    static let mockMembers: [MockMember] = [
        MockMember(nickname: "Ana"),
        MockMember(nickname: "Adi"),
        MockMember(nickname: "Ama"),
        MockMember(nickname: "Dad")
    ]
    
    // mock user
    static var mockUser: MockMember {
        mockMembers[0]
    }
}

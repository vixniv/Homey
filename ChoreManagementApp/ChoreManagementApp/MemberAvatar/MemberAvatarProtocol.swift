//
//  MemberAvatarProtocol.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import Foundation

protocol MemberAvatarProtocol : Identifiable {
    var nickname: String {get}
    var imageURL: URL? {get}
    func getNumberOfTask() -> Int
}

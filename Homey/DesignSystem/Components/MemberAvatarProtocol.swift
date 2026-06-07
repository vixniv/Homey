//
//  MemberAvatarProtocol.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import Foundation

// TODO: Review — unused protocol; the `Member` model is used directly. Revisit during the UI pass.
protocol MemberAvatarProtocol : Identifiable {
    var nickname: String {get}
    var imageURL: URL? {get}
    func getNumberOfTask() -> Int
}

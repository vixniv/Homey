//
//  MemberAvatar.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct MemberAvatarItem: View {
    var householdMember: HouseholdMemberModel
    var highlighted = true
    
    // Helper untuk mengambil 2 huruf pertama dan diubah ke uppercase
    private var initials: String {
        if householdMember.nickname.lowercased() == "all" {
            return "ALL"
        }
        return String(householdMember.nickname.prefix(2)).uppercased()
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if householdMember.nickname.lowercased() == "all" {
                    Circle()
                        .foregroundStyle(highlighted ? .appPrimary : .gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    Text(initials)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                } else {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(highlighted ? .appPrimary : Color.gray.opacity(0.3), lineWidth: 2)
                        )
                    
                    Text(initials)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.black)
                }
            }
            .frame(width: 54, height: 54)
            
            VStack(spacing: 2) {
                Text(householdMember.nickname)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(highlighted ? .primary : .secondary)
                
                Text("^[\(householdMember.numberOfTasks) task](inflect: true)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 60)
    }
}

#Preview {
    MemberAvatarItem(householdMember: HouseholdMemberModel(nickname: "Ana"))
}

#Preview {
    RootView()
}

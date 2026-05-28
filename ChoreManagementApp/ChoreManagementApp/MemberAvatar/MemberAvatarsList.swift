//
//  MemberAvatarsList.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct MemberAvatarsList<Member: MemberAvatarProtocol>: View {
    var user: Member // current user
    var members: [Member] // all family members
    var body: some View {
        HStack(spacing: 15) {
            // current user
            MemberAvatarItem(member: user,
                             highlighted: true)
            
            Divider()
            
            // all family members except the actual user
            ForEach(members) { member in
                if member.id != user.id {
                    MemberAvatarItem(member: member, highlighted: false)
                }
            }
            
        }
        .frame(height: 100)
    }
}

#Preview {
    
    
    MemberAvatarsList(user: MockMember.mockUser, members: MockMember.mockMembers)
}

//
//  MemberAvatarsList.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct MemberAvatarsList: View {
    var user: HouseholdMemberModel // current user
    var householdMembers: [HouseholdMemberModel] // all family members
    var showDivider = true
    var body: some View {
        HStack(spacing: 15) {
            // current user
            MemberAvatarItem(householdMember: user,
                             highlighted: true)
            
            if showDivider {
                Divider()
            }
            
            // all family members except the actual user
            ForEach(householdMembers) { member in
                if member.id != user.id {
                    MemberAvatarItem(householdMember: member, highlighted: false)
                }
            }
            
        }
        .frame(height: 100)
    }
}

#Preview {
    MemberAvatarsList(user: HouseholdMemberModel.mockUser, householdMembers: HouseholdMemberModel.mockMembers)
}

#Preview {
    ContentView(selectedTabItem: .home)
}

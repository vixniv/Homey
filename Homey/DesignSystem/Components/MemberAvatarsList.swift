//
//  MemberAvatarsList.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct MemberAvatarsList: View {
    var user: HouseholdMemberModel
    var householdMembers: [HouseholdMemberModel]
    var showDivider = true
    
    @Binding var selectedMemberId: UUID? // nil = "ALL"
    
    var body: some View {
        HStack(spacing: 15) {
            // Tombol ALL
            MemberAvatarItem(
                householdMember: user, // atau buat "All" member khusus
                highlighted: selectedMemberId == nil
            )
            .onTapGesture {
                selectedMemberId = nil
            }
            
            if showDivider { Divider() }
            
            ForEach(householdMembers) { member in
                if member.id != user.id {
                    MemberAvatarItem(
                        householdMember: member,
                        highlighted: selectedMemberId == member.id
                    )
                    .onTapGesture {
                        selectedMemberId = member.id
                    }
                }
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    MemberAvatarsList(
        user: HouseholdMemberModel.mockUser,
        householdMembers: HouseholdMemberModel.mockMembers,
        selectedMemberId: .constant(nil)
    )
}

#Preview {
    RootView()
}

//
//  AssignMembersView.swift
//  Scoers
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct AssignMembersView: View {
    
    var householdMembers = HouseholdMemberModel.mockMembers
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Assign to")
            HStack(spacing: 20) {
                ForEach(householdMembers){ member in
                    MemberAvatarItemSelectable(householdMember: member, isSelected: false, action: {})
                }
            }
        }
    }
}

#Preview {
    AssignMembersView()
}

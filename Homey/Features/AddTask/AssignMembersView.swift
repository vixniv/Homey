//
//  AssignMembersView.swift
//  Homey
//

import SwiftUI

// TODO: Review — unused; assignment is handled by MemberAvatarsList in AddTask. Revisit during the UI pass.
struct AssignMembersView: View {

    var members: [Member] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Assign to")
            HStack(spacing: 20) {
                ForEach(members) { member in
                    MemberAvatarItemSelectable(member: member, isSelected: .constant(false), action: {})
                }
            }
        }
    }
}

#Preview {
    AssignMembersView(members: [Member(id: UUID(), name: "Ana", emoji: "👧")])
}

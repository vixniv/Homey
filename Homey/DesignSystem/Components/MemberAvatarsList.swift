//
//  MemberAvatarsList.swift
//  Homey
//

import SwiftUI

struct MemberAvatarsList: View {
    var members: [Member]
    var showDivider = true

    @Binding var selectedMemberId: UUID? // nil = "All"

    var body: some View {
        HStack(spacing: 15) {
            MemberAvatarItem(emoji: "👥", name: "All", highlighted: selectedMemberId == nil)
                .onTapGesture { selectedMemberId = nil }

            if showDivider { Divider() }

            ForEach(members) { member in
                MemberAvatarItem(
                    emoji: member.emoji,
                    name: member.name,
                    highlighted: selectedMemberId == member.id
                )
                .onTapGesture { selectedMemberId = member.id }
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    MemberAvatarsList(
        members: [
            Member(id: UUID(), name: "Mom", emoji: "👩"),
            Member(id: UUID(), name: "Ana", emoji: "👧"),
        ],
        selectedMemberId: .constant(nil)
    )
}

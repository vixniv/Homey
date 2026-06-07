//
//  MemberAvatarItemSelectable.swift
//  Homey
//

import SwiftUI

// TODO: Review — unused; selectable avatar superseded by MemberAvatarsList. Revisit during the UI pass.
struct MemberAvatarItemSelectable: View {
    var member: Member
    var highlighted = false
    @Binding var isSelected: Bool

    var action: () -> Void // logic to select a household member

    var width: Double = 50

    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                if isSelected {
                    ZStack {
                        Circle()
                            .frame(width: width)
                            .foregroundStyle(Color("AppPrimaryColor"))

                        Circle()
                            .frame(width: width / 3)
                            .foregroundStyle(.white)
                    }
                } else {
                    Text(member.emoji)
                        .font(.system(size: width * 0.5))
                        .frame(width: width, height: width)
                        .background(Circle().fill(Color.gray.opacity(0.15)))
                }
            }

            Text(member.name)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    @Previewable @State var isSelected = false

    MemberAvatarItemSelectable(
        member: Member(id: UUID(), name: "Ana", emoji: "👧"),
        isSelected: $isSelected,
        action: { isSelected.toggle() }
    )
}

//
//  MemberAvatarItem.swift
//  Homey
//

import SwiftUI

struct MemberAvatarItem: View {
    let emoji: String
    let name: String
    var highlighted = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(highlighted ? .appPrimary : Color.gray.opacity(0.3), lineWidth: 2)
                    )

                Text(emoji)
                    .font(.system(size: 24))
            }
            .frame(width: 54, height: 54)

            Text(name)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(highlighted ? .primary : .secondary)
        }
        .frame(width: 60)
    }
}

#Preview {
    MemberAvatarItem(emoji: "👧", name: "Ana", highlighted: true)
}

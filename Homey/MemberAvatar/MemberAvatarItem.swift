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
    var body: some View {
        VStack {
            ZStack {
                if highlighted {
                    Circle()
                        .foregroundStyle(.appPrimary)
                        .frame(maxWidth: .infinity)
                }

                if let imageURL = householdMember.imageURL {
                    // TODO: load image if imageURL is valid
                } else {
                    Image("EmptyProfileImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .clipShape(Circle())
                }
            }

            VStack {
                Text(householdMember.nickname)
                    .foregroundStyle(.secondary)
                Text("^[\(householdMember.numberOfTasks) task](inflect: true)")
                    .font(.caption)
            }
        }
        .frame(width: 54)
    }
}

#Preview {
    MemberAvatarItem(householdMember: HouseholdMemberModel(nickname: "Ana"))
}

#Preview {
    ContentView()
}

//
//  MemberAvatar.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct MemberAvatarItemSelectable: View {
    var householdMember: HouseholdMemberModel
    var highlighted = false
    @Binding var isSelected: Bool

    var action: () -> Void // logic to select a household member

    var width: Double = 50

    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                if let imageURL = householdMember.imageURL {
                    // TODO: load image if imageURL is valid
                } else {
                    if isSelected {
                        ZStack {
                            Circle()
                                .scaledToFit()
                                .frame(width: width)
                                .foregroundStyle(Color("AppPrimaryColor"))
                            
                            Circle()
                                .scaledToFit()
                                .frame(width: width/3)
                                .foregroundStyle(.white)
                        }
                        
                    } else {
                        Image("EmptyProfileImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width)
                            .clipShape(Circle())
                    }
                }
            }
            
            //Text
            VStack {
                Text(householdMember.nickname)
                    .foregroundStyle(.secondary)
                Text("^[\(householdMember.numberOfTasks) task](inflect: true)")
            }
        }
    }
}

#Preview {
    @Previewable @State var isSelected = false

    MemberAvatarItemSelectable(householdMember: HouseholdMemberModel(nickname: "Ana"), isSelected: $isSelected, action: { isSelected.toggle() })
}

#Preview {
    ContentView()
}

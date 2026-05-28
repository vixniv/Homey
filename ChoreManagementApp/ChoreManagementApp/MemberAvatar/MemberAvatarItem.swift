//
//  MemberAvatar.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct MemberAvatarItem: View {
    var member: any MemberAvatarProtocol
    var highlighted = false
    var body: some View {
        VStack {
            ZStack {
                // add highlight (as a circular border and shadow)
                if highlighted {
                    Circle()
                        .foregroundStyle(.blue)
                        .frame(width: 54)
                        .shadow(radius: 15)
                }
                
                if let imageURL = member.imageURL {
                    // TODO: load image if imageURL is valid
                } else {
                    Image("EmptyProfileImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .clipShape(Circle())
                }
                    
            }
            
            //Text
            VStack {
                Text(member.nickname)
                    .foregroundStyle(.secondary)
                Text("^[\(member.getNumberOfTask()) task](inflect: true)")
            }
        }
    }
}

#Preview {
    MemberAvatarItem(member: MockMember(nickname: "Ana"))
}

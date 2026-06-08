//
//  AddHomeMembers.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 05/06/26.
//

import SwiftUI

struct InviteHomeMembersView: View {
    
    @State private var isShowingNextPage = false
    
    var body: some View {
        VStack() {
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 64, height: 64)
                        .foregroundStyle(.taskBlue)
                    
                    Image(systemName: "person.2")
                        .foregroundStyle(.appPrimary)
                }
                
                Text("No Members yet")
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 5)
                Text("Invite your family to share chores together")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding()
            
            PrimaryButton(title: "Invite via QR Code") {
                
            }
            PrimaryButton(title: "Invite via link", type: "secondary") {}
            
            Spacer()
        }
        .navigationTitle("Add home members")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                PrimaryButton(title: "Finish") {
                    // TODO: finish function
                    isShowingNextPage = true
                }
            }
        }
        .padding()
        .navigationDestination(isPresented: $isShowingNextPage) {
            HomeView()
        }
    }
}

#Preview {
    NavigationStack {
        InviteHomeMembersView()
    }
}

//
//  NewHomeView.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 05/06/26.
//

import SwiftUI

struct NewHomeOnboardingView: View {
    @State private var isShowingNextPage = false
    @State private var isShowingJoinPage = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, Color("AppPrimaryColor")], startPoint: .top, endPoint: .bottom)
            
            VStack {
                
                
                HStack {
                    Spacer()
                    ZStack {
                        Capsule()
                            .foregroundStyle(.white)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .rotationEffect(Angle(degrees: 45))
                            .offset(x: -35, y: 40)
                        
                        Text("You seem not to have been to any house yet.")
                            .foregroundStyle(.primary)
                            .padding()
                        
                    }
                    .frame(width: 230, height: 100)
                }
                
                Image(ImageResource.sadHomey)
                PrimaryButton(title: "Start a new home", type: "primary") {
                    isShowingNextPage = true
                }
                .navigationDestination(isPresented: $isShowingNextPage) {
                    NewHomeNameFormView()
                }
                
                PrimaryButton(title: "Join an existing home", type: "secondary") {
                    isShowingJoinPage = true
                }
                .navigationDestination(isPresented: $isShowingJoinPage) {
                    JoinHomeFormView()
                }
            }
            .padding()
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    NavigationStack {
        NewHomeOnboardingView()
    }
}

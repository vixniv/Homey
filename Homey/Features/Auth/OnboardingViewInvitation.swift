//
//  OnboardingViewInvitation.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 08/06/26.
//

import SwiftUI

struct OnboardingViewInvitation: View {
    var body: some View {
        VStack{
            NavigationStack{
                Spacer()
                Image("logo1")
                    .padding(.bottom, 20)
                Text("Welcome to Homey!")
                    .font(.title)
                    .bold()
                Text("You've been added to a shared home. Log in or sign up to see your chores.")
                    .font(.title2)
                    .padding(.horizontal, 40)
                    .padding(.top, 3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Spacer()
                
                NavigationLink{
                    SignInView()
                } label: {
                    Text("Login")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .background(.appPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(color: .appPrimary.opacity(0.4), radius: 5, x:0, y:6)
                .padding(.horizontal, 20)
                
                NavigationLink{
                    SignupView()
                } label: {
                    Text("Register")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                }
                .background(.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(color: .secondary.opacity(0.2), radius: 5, x:0, y:6)
                .padding(.horizontal, 20)
                
                .padding(.bottom, 50)

            }
        }
    }
}

#Preview {
    OnboardingViewInvitation()
}

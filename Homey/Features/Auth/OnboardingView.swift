//
//  OnboardingView.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 03/06/26.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack {
            NavigationStack{
                Spacer()
                Image("logo1")
                    .padding(.bottom, 20)
                Text("Welcome to Homey!")
                    .font(.title)
                    .bold()
                Text("Add, organize, and assign house chores easily in one app.")
                    .font(.title2)
                    .padding(.horizontal, 20)
                    .padding(.top, 3)
                    .multilineTextAlignment(.center)

                Spacer()
                
                NavigationLink{
                    SignInView()
                } label: {
                    Text("Start")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.appPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    OnboardingView()
}

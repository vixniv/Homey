//
//  OnboardingView.swift
//  Homey
//

import SwiftUI

struct OnboardingView: View {
    let onDemo: () -> Void

    var body: some View {
        NavigationStack {
            VStack {
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

                NavigationLink {
                    SignInView(onDemo: onDemo)
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
                        .padding(.top, 100)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    OnboardingView(onDemo: {})
}

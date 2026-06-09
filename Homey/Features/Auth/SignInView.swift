//
//  SignInView.swift
//  Homey
//

import SwiftUI

struct SignInView: View {
    /// Demo entry, injected by the auth gate. Defaults to a no-op so the
    /// screen can also be reached from the sign-up link / invitation flow.
    var onDemo: () -> Void = {}

    @State private var emailStr = ""
    @State private var passwordStr = ""
    @State private var rememberMe = false

    var body: some View {
        VStack(spacing: 16) {

            Spacer()
            Spacer()

            Text("Create Your Scheduled, Organized House Chores")
                .font(.title)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            PrimaryButton(title: "Try Demo") {
                onDemo()
            }
            .padding(.top, 8)

            Text("Explore a ready-made household with members and chores.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading) {
                Text("Email")
                TextField("Enter your email here", text: $emailStr)
                    .textFieldStyle()
            }

            VStack(alignment: .leading) {
                Text("Password")
                TextField("Enter your password here", text: $passwordStr)
                    .textFieldStyle()
            }

            HStack {
                Checkbox(isOn: $rememberMe, diameter: 24)
                Text("Remember me")
                Spacer()
            }

            PrimaryButton(title: "Sign in") {
                // TODO: Sign in logic
            }

            HStack {
                Rectangle()
                    .frame(width: 100, height: 0.5)
                    .opacity(0.5)
                Text("Or continue with")
                    .padding(.horizontal, 5)
                Rectangle()
                    .frame(width: 100, height: 0.5)
                    .opacity(0.5)
            }
            .padding(.vertical)

            AuthButtonGoogle {

            }

            AuthButtonApple {

            }

            Spacer()
            Spacer()

            HStack {
                Text("Don't have an account?")
                NavigationLink {
                    SignupView()
                } label: {
                    Text("Sign up")
                        .underline()
                }
            }

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        SignInView()
    }
}

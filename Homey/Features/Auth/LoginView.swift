//
//  LoginView.swift
//  Homey
//

import SwiftUI

struct LoginView: View {
    let onDemo: () -> Void

    @State private var emailStr = ""
    @State private var passwordStr = ""

    var body: some View {
        VStack {
            Text("Create Your Scheduled, Organized House Chores")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.top, 50)
                .fixedSize(horizontal: false, vertical: true)

            PrimaryButton(title: "Try Demo") {
                onDemo()
            }
            .padding(.top, 24)

            Text("Explore a ready-made household with members and chores.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)

            HStack {
                Rectangle().frame(width: 100, height: 0.5).opacity(0.5)
                Text("Or sign up (coming soon)").font(.footnote).padding(.horizontal, 5)
                Rectangle().frame(width: 100, height: 0.5).opacity(0.5)
            }
            .padding(.vertical, 24)

            VStack(alignment: .leading) {
                Text("Email")
                TextField("Enter your email here", text: $emailStr)
                    .textFieldStyle()
            }
            .padding(.bottom)

            VStack(alignment: .leading) {
                Text("Password")
                TextField("Enter your password here", text: $passwordStr)
                    .textFieldStyle()
            }
            .padding(.bottom)

            PrimaryButton(title: "Sign Up") {}
                .disabled(true)
                .opacity(0.4)

            AuthButtonGoogle {}
                .disabled(true)
                .opacity(0.4)

            AuthButtonApple {}
                .disabled(true)
                .opacity(0.4)

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        LoginView(onDemo: {})
    }
}

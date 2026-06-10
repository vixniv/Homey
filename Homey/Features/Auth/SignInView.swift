//
//  SignInView.swift
//  Homey
//

import SwiftUI
import Supabase

struct SignInView: View {
    /// Demo entry, injected by the auth gate. Defaults to a no-op so the
    /// screen can also be reached from the sign-up link / invitation flow.
    var onDemo: () -> Void = {}

    @State private var emailStr = ""
    @State private var passwordStr = ""
    @State private var rememberMe = false
    @State private var isLoading = false
    @State private var errorMessage: String?

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
                SecureField("Enter your password here", text: $passwordStr)
                    .textFieldStyle()
            }

            HStack {
                Checkbox(isOn: $rememberMe, diameter: 24)
                Text("Remember me")
                Spacer()
            }

            if isLoading {
                ProgressView()
                    .padding()
            } else {
                PrimaryButton(title: "Sign in") {
                    Task {
                        await signIn()
                    }
                }
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
        .alert(isPresented: Binding(
            get: { errorMessage != nil },
            set: { _ in errorMessage = nil }
        )) {
            Alert(title: Text("Sign In Failed"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func signIn() async {
        guard !emailStr.isEmpty, !passwordStr.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            try await SupabaseClientProvider.shared.auth.signIn(email: emailStr, password: passwordStr)
            // On success, RootViewModel's authStateChanges listener will automatically handle routing.
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        SignInView()
    }
}

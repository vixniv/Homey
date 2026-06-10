//
//  SignUpPage.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 03/06/26.
//

import SwiftUI
import Supabase

struct SignupView: View {
    
    @State private var emailStr = ""
    @State private var passwordStr = ""
    @State private var confirmPasswordStr = ""
    @State private var isLoading = false
    @State private var alertMessage: String?
    @State private var isSuccess = false
    
    var body: some View {
        ScrollView {
            VStack {
                
                Text("Create Your Scheduled, Organized House Chores")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                    .fixedSize(horizontal: false, vertical: true)

                
                VStack(alignment: .leading) {
                    Text("Email")
                    TextField("Enter your email here", text: $emailStr)
                        .textFieldStyle()
                }
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("Password")
                    SecureField("Enter your password here", text: $passwordStr)
                        .textFieldStyle()
                }
                .padding(.bottom)
                
                VStack(alignment: .leading){
                    Text("Confirm password")
                    SecureField("Confirm your password here", text: $confirmPasswordStr)
                        .textFieldStyle()
                }
                .padding(.bottom, 32)
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    PrimaryButton(title: "Sign Up") {
                        Task {
                            await signUp()
                        }
                    }
                }
                
                AuthButtonApple {
                    
                }
                
                
                Spacer()
                Spacer()
                
                HStack {
                    Text("Already have an account?")
                    NavigationLink {
                        SignInView()
                    } label: {
                        Text("Sign in")
                            .underline()
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden()
            .alert(isPresented: Binding(
                get: { alertMessage != nil },
                set: { _ in alertMessage = nil }
            )) {
                Alert(
                    title: Text(isSuccess ? "Success" : "Sign Up Failed"),
                    message: Text(alertMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func signUp() async {
        guard !emailStr.isEmpty, !passwordStr.isEmpty, !confirmPasswordStr.isEmpty else {
            isSuccess = false
            alertMessage = "Please fill in all fields."
            return
        }
        
        guard passwordStr == confirmPasswordStr else {
            isSuccess = false
            alertMessage = "Passwords do not match."
            return
        }

        isLoading = true
        alertMessage = nil

        do {
            try await SupabaseClientProvider.shared.auth.signUp(
                email: emailStr,
                password: passwordStr,
                data: [
                    "name": .string("New Member"),
                    "emoji": .string("👤")
                ]
            )
            isSuccess = true
            alertMessage = "Account created successfully! You can now sign in."
        } catch {
            isSuccess = false
            alertMessage = error.localizedDescription
        }

        isLoading = false
    }
}



#Preview {
    NavigationStack {
        SignupView()
    }
}

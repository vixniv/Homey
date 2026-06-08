//
//  LoginView.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 03/06/26.
//

import SwiftUI

struct SignInView: View {
    
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
                Text("Already have an account?")
                Button {
                    
                } label: {
                    Text("Login")
                        .underline()
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignInView()
}

//
//  SignUpPage.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 03/06/26.
//

import SwiftUI

struct SignupView: View {
    
    @State private var emailStr = ""
    @State private var passwordStr = ""
    @State private var confirmPasswordStr = ""
    
    var body: some View {
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
                TextField("Enter your password here", text: $passwordStr)
                    .textFieldStyle()
            }
            .padding(.bottom)
            
            VStack(alignment: .leading){
                Text("Confirm password")
                TextField("Confirm your password here", text: $confirmPasswordStr)
                    .textFieldStyle()
            }
            .padding(.bottom, 32)
            
            PrimaryButton(title: "Sign Up") {
                
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
    }
}



#Preview {
    SignupView()
}

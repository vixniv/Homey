//
//  ProfileSetupView.swift
//  Homey
//
//  Created by Antigravity on 06/10/26.
//

import SwiftUI
import Supabase

struct ProfileSetupView: View {
    @Environment(RootViewModel.self) private var rootModel
    @State private var nameStr = ""
    @State private var emojiStr = "👤"
    @State private var isLoading = false
    @State private var isProfileCompleted = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("What should we call you?")
                    .font(.headline)
                
                TextField("Your Name", text: $nameStr)
                    .textFieldStyle()
                
                Text("This is how your name appears to all members.")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            
            VStack(spacing: 8) {
                Text("Choose your avatar emoji")
                    .font(.headline)
                
                EmojiTextField(text: $emojiStr, placeholder: "👤", fontSize: 40)
                    .frame(width: 80, height: 80)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                Text("This emoji represents you in task assignments.")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .navigationTitle("Set up profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isLoading {
                    ProgressView()
                } else {
                    PrimaryButton(title: "Next") {
                        Task {
                            await saveProfile()
                        }
                    }
                }
            }
        }
        .padding()
        .navigationDestination(isPresented: $isProfileCompleted) {
            NewHomeOnboardingView()
                .navigationBarBackButtonHidden(true)
        }
        .alert(isPresented: Binding(
            get: { errorMessage != nil },
            set: { _ in errorMessage = nil }
        )) {
            Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
        .task {
            await checkIfProfileCompleted()
        }
    }
    
    private func checkIfProfileCompleted() async {
        do {
            let session = try await SupabaseClientProvider.shared.auth.session
            let user = session.user
            let metadata = user.userMetadata
            let name = metadata["name"]?.stringValue ?? "New Member"
            if name != "New Member" && !name.isEmpty {
                isProfileCompleted = true
            }
        } catch {
            // User might not be fully signed in yet, let RootViewModel handle routing.
        }
    }
    
    private func saveProfile() async {
        guard !nameStr.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter your name."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await SupabaseClientProvider.shared.auth.update(
                user: UserAttributes(
                    data: [
                        "name": .string(nameStr.trimmingCharacters(in: .whitespacesAndNewlines)),
                        "emoji": .string(emojiStr.isEmpty ? "👤" : emojiStr)
                    ]
                )
            )
            isProfileCompleted = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        ProfileSetupView()
            .environment(RootViewModel())
    }
}

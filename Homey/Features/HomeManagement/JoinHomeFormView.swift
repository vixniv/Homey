//
//  JoinHomeFormView.swift
//  Homey
//

import SwiftUI
import Dependencies
import Supabase

struct JoinHomeFormView: View {
    @Environment(RootViewModel.self) private var rootModel
    @Dependency(\.householdClient) private var householdClient
    
    @State private var inviteCode: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            Text("Enter Invite Code")
            TextField("e.g. 123456", text: $inviteCode)
                .textFieldStyle()
                .keyboardType(.numberPad)
            Text("Ask a member of the household for a 6-digit code.")
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Spacer()
        }
        .navigationTitle("Join a home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isLoading {
                    ProgressView()
                } else {
                    PrimaryButton(title: "Join") {
                        Task {
                            await joinHome()
                        }
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: Binding(
            get: { errorMessage != nil },
            set: { _ in errorMessage = nil }
        )) {
            Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func joinHome() async {
        let code = inviteCode.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !code.isEmpty else {
            errorMessage = "Please enter an invite code."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            try await householdClient.joinHousehold(code: code)
            rootModel.completeOnboarding()
        } catch {
            errorMessage = "Invalid or expired invite code."
        }

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        JoinHomeFormView()
            .environment(RootViewModel())
    }
}

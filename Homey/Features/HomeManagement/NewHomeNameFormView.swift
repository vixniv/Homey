//
//  HomeForm1.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 05/06/26.
//

import SwiftUI
import Supabase

struct NewHomeNameFormView: View {
    @Environment(RootViewModel.self) private var rootModel
    @State private var homeName: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            Text("What's your home called?")
            TextField("The Johnsons, Casa Familia", text:$homeName)
                .textFieldStyle()
            Text("This is how your home appears to all members.")
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Spacer()
        }
        .navigationTitle("Start a new home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                if isLoading {
                    ProgressView()
                } else {
                    PrimaryButton(title: "Next") {
                        Task {
                            await createHome()
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

    private func createHome() async {
        guard !homeName.isEmpty else {
            errorMessage = "Please enter a home name."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let session = try await SupabaseClientProvider.shared.auth.session
            let user = session.user
            let metadata = user.userMetadata
            
            let name = metadata["name"]?.stringValue ?? "New Member"
            let emoji = metadata["emoji"]?.stringValue ?? "👤"

            let newHousehold = Household(id: UUID(), name: homeName)
            try await SupabaseClientProvider.shared
                .from("households")
                .insert(newHousehold)
                .execute()

            let newMember = Member(
                id: user.id,
                householdId: newHousehold.id,
                name: name,
                emoji: emoji,
                role: .admin
            )
            try await SupabaseClientProvider.shared
                .from("members")
                .insert(newMember)
                .execute()

            rootModel.completeOnboarding()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        NewHomeNameFormView()
            .environment(RootViewModel())
    }
}

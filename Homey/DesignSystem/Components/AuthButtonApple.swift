import SwiftUI
import AuthenticationServices
import Supabase

struct AuthButtonApple: View {
    @State private var currentNonce: String?
    @State private var alertMessage: String?
    @State private var showError = false

    var type: String?
    var color: Color = Color("AppPrimaryColor")
    let action: () -> Void
    
    var body: some View {
        SignInWithAppleButton(
            .continue,
            onRequest: { request in
                let nonce = AppleSignInHelper.randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = AppleSignInHelper.sha256(nonce)
            },
            onCompletion: { result in
                switch result {
                case .success(let authorization):
                    handleAppleSignIn(authorization: authorization)
                case .failure(let error):
                    if (error as NSError).code != ASAuthorizationError.canceled.rawValue {
                        alertMessage = error.localizedDescription
                        showError = true
                    }
                }
            }
        )
        .signInWithAppleButtonStyle(.white)
        .frame(height: 55)
        .clipShape(Capsule())
        .glassEffect()
        .alert(isPresented: $showError) {
            Alert(title: Text("Sign In Failed"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
    
    private func handleAppleSignIn(authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }

        guard let currentNonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }

        guard let appleIDToken = appleIDCredential.identityToken else {
            alertMessage = "Unable to fetch identity token."
            showError = true
            return
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            alertMessage = "Unable to serialize token string from data."
            showError = true
            return
        }

        Task {
            do {
                try await SupabaseClientProvider.shared.auth.signInWithIdToken(
                    credentials: .init(
                        provider: .apple,
                        idToken: idTokenString,
                        nonce: currentNonce
                    )
                )

                // If Apple provided a fullName (which only happens on the first sign-in),
                // update the user's metadata so Supabase triggers can populate the member table.
                if let fullName = appleIDCredential.fullName {
                    let givenName = fullName.givenName ?? ""
                    let familyName = fullName.familyName ?? ""
                    let nameStr = [givenName, familyName].filter { !$0.isEmpty }.joined(separator: " ")
                    
                    if !nameStr.isEmpty {
                        let data: [String: AnyJSON] = [
                            "name": .string(nameStr),
                            "emoji": .string("👤")
                        ]
                        try? await SupabaseClientProvider.shared.auth.update(user: UserAttributes(data: data))
                    }
                }

                action()
            } catch {
                alertMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

#Preview {
    AuthButtonApple() {}
        .padding()
}

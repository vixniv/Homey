//
//  RootView.swift
//  Homey
//

import SwiftUI

struct RootView: View {
    @State private var model = RootViewModel()

    var body: some View {
        Group {
            switch model.route {
            case .auth:
                OnboardingView(onDemo: { model.signInDemo() })
            case .onboarding:
                NavigationStack {
                    ProfileSetupView()
                }
            case .signedIn:
                MainScene()
            }
        }
        .environment(model)
    }
}

#Preview {
    RootView()
}

//
//  RootView.swift
//  Homey
//

import SwiftUI

struct RootView: View {
    @State private var model = RootViewModel()

    var body: some View {
        switch model.route {
        case .auth:
            OnboardingView(onDemo: { model.signInDemo() })
        case .signedIn:
            MainScene()
        }
    }
}

#Preview {
    RootView()
}

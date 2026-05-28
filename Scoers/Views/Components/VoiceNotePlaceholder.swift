//
//  VoiceNotePlaceholder.swift
//  Scoers
//

import SwiftUI

struct VoiceNotePlaceholder: View {
    var color: Color = .appPrimary

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "mic")
                .font(.system(size: 20))
                .foregroundColor(.primary)
            Text("Record your voice")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color))
        .padding(.horizontal)
    }
}

#Preview {
    VoiceNotePlaceholder()
}

//
//  VoiceNotePlaceholder.swift
//  Scoers
//

import SwiftUI

// TODO: Review — placeholder with no recording logic; wire up real voice notes or remove.
struct VoiceNotePlaceholder: View {
    var color: Color = Color.gray.opacity(0.3)

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
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(color))
        .padding(.horizontal)
    }
}

#Preview {
    VoiceNotePlaceholder()
}

//
//  InstructionInput.swift
//  Homey
//

import SwiftUI

struct InstructionInput: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text("Instruction")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.25))
                Text("(Optional)")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.55))
            }
            .padding(.bottom, 10)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(red: 0.88, green: 0.88, blue: 0.92), lineWidth: 1)
                    )

                TextEditor(text: $text)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.25))
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
            }
            .frame(height: 110)
        }
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @State var text = ""
    return ZStack {
        Color(red: 0.95, green: 0.95, blue: 0.97).ignoresSafeArea()
        InstructionInput(text: $text)
    }
}

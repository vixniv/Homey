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
//                    .foregroundColor(Color.black)
                Text("(Optional)")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.55))
            }
            .padding(.bottom, 10)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(.system(size: 16, weight: .regular))
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.bgInput)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 0.5) // ← satu border tipis
                    )
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

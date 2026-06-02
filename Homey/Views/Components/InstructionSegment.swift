//
//  InstructionSegment.swift
//  Scoers
//

import SwiftUI

struct InstructionSegment: View {
    @Binding var selection: InstructionType
    var color: Color = .appPrimary

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Instruction")
                .font(.system(size: 14, weight: .regular))

            HStack(spacing: 10) {
                segment(title: "Voice Note", isSelected: selection == .voiceNote) {
                    selection = .voiceNote
                }
                segment(title: "Notes", isSelected: selection == .notes) {
                    selection = .notes
                }
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func segment(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? color : Color.clear)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(color))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    @Previewable @State var selection: InstructionType = .voiceNote
    InstructionSegment(selection: $selection)
}

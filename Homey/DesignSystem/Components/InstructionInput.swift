//
//  InstructionInput.swift
//  Homey
//
//  Created by Yoram on 04/06/26.
//

import SwiftUI

struct InstructionInput: View {
    @State private var instructionText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label
            HStack(spacing: 4) {
                Text("Instruction")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.25))
                Text("(Optional)")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.55))
            }
            .padding(.bottom, 10)
            
            // Text Editor
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(red: 0.88, green: 0.88, blue: 0.92), lineWidth: 1)
                    )
//                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                
                TextEditor(text: $instructionText)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.25))
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
            }
            .frame(height: 110)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        Color(red: 0.95, green: 0.95, blue: 0.97)
            .ignoresSafeArea()
        InstructionInput()
    }
}

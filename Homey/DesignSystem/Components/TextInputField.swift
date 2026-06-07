//
//  TextInputField.swift
//  Scoers
//
//  Created by Nadila Rizky Amelia on 28/05/26.
//

import SwiftUI

struct TextInputField: View {

    @Binding var choreTitle: String
    var color: Color = Color.gray.opacity(0.3)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Task Title")
                .font(.system(size: 18, weight: .semibold))
                .padding(.bottom, 10)
            TextField("Enter Task Title Here", text: $choreTitle)
                .padding(17)
                .font(.system(size: 16, weight: .regular))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(color)
                )
        }
        .padding(.horizontal)
    }
}
#Preview {
    TextInputField(choreTitle: .constant(""))
}

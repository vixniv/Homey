//
//  TextInputField.swift
//  Scoers
//
//  Created by Nadila Rizky Amelia on 28/05/26.
//

import SwiftUI

struct TextInputField: View {

    @Binding var choreTitle: String
    var color: Color = Color(red: 124/255, green: 196/255, blue: 240/255)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Task")
                .font(.system(size: 14, weight: .regular))
            TextField("Clean the bathroom", text: $choreTitle)
                .padding(12)
                .font(.system(size: 16, weight: .regular))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color)
                )
        }
        .padding(.horizontal)
    }
}
#Preview {
    TextInputField(choreTitle: .constant(""))
}

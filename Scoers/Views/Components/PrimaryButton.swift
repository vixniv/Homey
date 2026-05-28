//
//  PrimaryButton.swift
//  Scoers
//
//  Created by Yoram on 28/05/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var color: Color = Color(red: 124/255, green: 196/255, blue: 240/255)

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(color)
                .cornerRadius(12)
        }
    }
}

#Preview {
    PrimaryButton(title: "+ Add task") {}
        .padding()
}

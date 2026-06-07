//
//  PrimaryButton.swift
//  Scoers
//
//  Created by Yoram on 28/05/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var type: String?
    var color: Color = Color("AppPrimaryColor")
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(type == "secondary" ? .black : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .glassEffect(.regular.tint(type == "secondary" ? .white : Color("AppPrimaryColor")), in: Capsule())
        
    }
}

#Preview {
    PrimaryButton(title: "Create Task") {}
        .padding()
}

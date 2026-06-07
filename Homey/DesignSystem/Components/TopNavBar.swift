//
//  TopNavBar.swift
//  Homey
//
//  Created by Yoram on 03/06/26.
//

import SwiftUI

struct TopNavBar: View {
    let title: String
    var leadingAction: (() -> Void)? = nil
    var leadingIcon: String = "xmark"          // default X, bisa diganti "chevron.left"
    var trailingIcon: String? = nil             // optional icon kanan (misal "gear")
    var trailingAction: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 20, weight: .semibold))

            HStack {
                if let action = leadingAction {
                    Button(action: action) {
                        Image(systemName: leadingIcon)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                            .frame(width: 40, height: 40)
                            .background(Color(.systemGray5))
                            .clipShape(Circle())
                    }
                } else {
                    Spacer().frame(width: 36)
                }

                Spacer()

                if let trailingIcon, let trailingAction {
                    Button(action: trailingAction) {
                        Image(systemName: trailingIcon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                } else {
                    Spacer().frame(width: 36)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .frame(height: 52)
    }
}

#Preview {
    TopNavBar(title: "Add Task")
}

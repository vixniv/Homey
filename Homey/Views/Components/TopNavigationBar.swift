//
//  TopNavigationBar.swift
//  Scoers
//
//  Created by Yoram on 28/05/26.
//

import SwiftUI

struct TopNavigationBar: View {
    let title: String
    var onBack: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Button(action: {
                    onBack?()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.primary)
                        .padding(.leading, 16)
                }
                Spacer()
            }
        }
        .frame(height: 44)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator)),
            alignment: .bottom
        )
    }
}

#Preview {
    VStack(spacing: 0) {
        TopNavigationBar(title: "Add Task") {
            print("Back tapped")
        }
        Spacer()
    }
    .background(Color(.systemGroupedBackground))
}

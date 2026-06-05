//
//  NavigationToolbar.swift
//  Homey
//
//  Created by Yoram on 05/06/26.
//

import SwiftUI

struct NavigationToolbar: ViewModifier {
    let title: String
    var leadingIcon: String = "chevron.left"
    var leadingAction: (() -> Void)? = nil
    var trailingIcon: String? = nil
    var trailingAction: (() -> Void)? = nil

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Leading button
                ToolbarItem(placement: .topBarLeading) {
                    if let action = leadingAction {
                        Button(action: action) {
                            Image(systemName: leadingIcon)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                    }
                }

                // Centered title
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                }

                // Trailing button (optional)
                ToolbarItem(placement: .topBarTrailing) {
                    if let icon = trailingIcon, let action = trailingAction {
                        Button(action: action) {
                            Image(systemName: icon)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
    }
}

// MARK: - View Extension

extension View {
    func navigationToolbar(
        title: String,
        leadingIcon: String = "chevron.left",
        leadingAction: (() -> Void)? = nil,
        trailingIcon: String? = nil,
        trailingAction: (() -> Void)? = nil
    ) -> some View {
        modifier(NavigationToolbar(
            title: title,
            leadingIcon: leadingIcon,
            leadingAction: leadingAction,
            trailingIcon: trailingIcon,
            trailingAction: trailingAction
        ))
    }
}

//
//  Toggle.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 07/06/26.
//

import SwiftUI

struct ToggleFeature: View {
    let title: String
        let subtitle: String
        @Binding var isOn: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Toggle("", isOn: $isOn)
                        .labelsHidden()
                        .tint(.green)
                }
            }
            .padding(.vertical, 8)
        }
}

#Preview {
    ToggleFeature(
        title: "Enable Notification",
        subtitle: "Receive reminders every day",
        isOn: .constant(true)
    )
    .padding()
}

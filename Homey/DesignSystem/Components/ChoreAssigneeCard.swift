//
//  ChoreAssigneeCard.swift
//  Homey
//
//  Created by Yoram on 05/06/26.
//

import SwiftUI

struct ChoreAssigneeCard: View {
    let memberName: String
    let memberInitials: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack(spacing: 6) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.appPrimary)

                Text("Assignee")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.appPrimary)
            }

            // Member row
            HStack(spacing: 12) {
                // Avatar circle with initials
                ZStack {
                    Circle()
                        .fill(Color.appPrimary)
                        .frame(width: 44, height: 44)

                    Text(memberInitials)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(memberName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    ChoreAssigneeCard(
        memberName: "Mom",
        memberInitials: "MO",
        subtitle: "Primary asignee"
    )
    .padding()
}

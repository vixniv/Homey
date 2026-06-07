//
//  HouseholdProgressCard.swift
//  Homey
//

import SwiftUI

struct HouseholdProgressCard: View {
    let householdName: String
    let memberEmojis: [String]
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(householdName)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                HStack(spacing: -8) {
                    ForEach(Array(memberEmojis.prefix(4).enumerated()), id: \.offset) { _, emoji in
                        Text(emoji)
                            .font(.system(size: 14))
                            .frame(width: 26, height: 26)
                            .background(Circle().fill(Color(.systemBackground)))
                            .overlay(Circle().stroke(Color(.systemGray4), lineWidth: 1))
                    }
                }
            }
            ProgressView(value: progress)
                .tint(Color.appPrimary)
            Text("\(Int((progress * 100).rounded()))% of chores completed")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(
            Color(.secondarySystemBackground),
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
    }
}

#Preview {
    HouseholdProgressCard(
        householdName: "Ana's Family House",
        memberEmojis: ["👩", "👨", "👧", "🧒"],
        progress: 0.68
    )
    .padding()
}

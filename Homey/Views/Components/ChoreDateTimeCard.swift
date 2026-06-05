//
//  ChoreDateTimeCard.swift
//  Homey
//
//  Created by Yoram on 05/06/26.
//

import SwiftUI

// MARK: - Date Card

struct ChoreDateCard: View {
    let date: Date

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "dd / MM / yyyy"
        return f
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 5) {
                Image(systemName: "calendar")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.appPrimary)

                Text("Date")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.secondary)
            }

            Text(dateFormatter.string(from: date))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// MARK: - Deadline Card

struct ChoreDeadlineCard: View {
    let deadlineTime: Date
    let earlyNote: String?

    private var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "hh.mm a"
        return f
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 5) {
                Image(systemName: "clock.badge.checkmark")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.appPrimary)

                Text("Must be done by")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.secondary)
            }

            Text(timeFormatter.string(from: deadlineTime))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)

            if let note = earlyNote {
                Text(note)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.badgeGreen)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// MARK: - Previews

#Preview {
    HStack(spacing: 12) {
        ChoreDateCard(date: Date())
        ChoreDeadlineCard(deadlineTime: Date(), earlyNote: "Done 30 min early")
    }
    .padding()
//    .fixedSize(horizontal: false, vertical: true)
}

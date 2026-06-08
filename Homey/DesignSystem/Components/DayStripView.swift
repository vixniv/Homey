//
//  DayStripView.swift
//  Homey
//

import SwiftUI

struct DayStripView: View {
    let days: [Date]
    let selectedDate: Date
    let onSelect: (Date) -> Void

    private let calendar = Calendar(identifier: .gregorian)

    var body: some View {
        HStack(spacing: 6) {
            ForEach(days, id: \.self) { day in
                let isSelected = calendar.isDate(day, inSameDayAs: selectedDate)
                Button {
                    onSelect(day)
                } label: {
                    VStack(spacing: 6) {
                        Text(weekdayLabel(day))
                            .font(.caption2)
                            .foregroundStyle(isSelected ? Color(.systemBackground) : .secondary)
                        Text(dayNumber(day))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(isSelected ? Color(.systemBackground) : .primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        isSelected ? Color.primary : Color.clear,
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func weekdayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    private func dayNumber(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

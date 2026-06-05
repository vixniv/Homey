//
//  ChoreStatusBadge.swift
//  Homey
//
//  Created by Yoram on 05/06/26.
//

import SwiftUI

struct ChoreStatusBadge: View {
    let state: TaskState
    let completedDate: Date?

    private var icon: String {
        switch state {
        case .done:
            return "checkmark.circle"
        case .inProgress:
            return "clock.arrow.circlepath"
        case .late:
            return "exclamationmark.circle"
        case .available:
            return "circle"
        }
    }

    private var title: String {
        switch state {
        case .done:       return "Completed on time"
        case .inProgress: return "In Progress"
        case .late:       return "Overdue by 3 hours"
        case .available:  return "Available"
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .done:       return .taskGreen
        case .inProgress: return .taskYellow
        case .late:       return Color(.taskRed)
        case .available:  return .taskBlue
        }
    }

    private var foregroundColor: Color {
        switch state {
        case .done:       return .textGreen
        case .inProgress: return .textYellow
        case .late:       return Color(.textRed)
        case .available:  return .textBlue
        }
    }

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy 'at' hh:mm a"
        return f
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(foregroundColor)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(foregroundColor)

                if let date = completedDate {
                    Text(dateFormatter.string(from: date))
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(foregroundColor)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 12) {
        ChoreStatusBadge(state: .done, completedDate: Date())
        ChoreStatusBadge(state: .inProgress, completedDate: nil)
        ChoreStatusBadge(state: .late, completedDate: Date())
    }
    .padding()
}

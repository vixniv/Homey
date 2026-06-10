//
//  DailyActivity.swift
//  Homey
//

import SwiftUI

struct DailyActivityChart: View {
    
    struct DayData: Identifiable {
        let id = UUID()
        let label: String
        let value: Double
    }
    
    let data: [DayData] = [
        DayData(label: "Mon", value: 0.30),
        DayData(label: "Tue", value: 0.55),
        DayData(label: "Wed", value: 0.75),
        DayData(label: "Thu", value: 0.35),
        DayData(label: "Fri", value: 0.60),
        DayData(label: "Sat", value: 0.70),
        DayData(label: "Sun", value: 0.85),
    ]
    
    // Today is Wednesday (index 2)
    let todayIndex = 2
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Header
            Text("Daily Activity")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Task completed per day")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
            
            // Bar Chart
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, day in
                    VStack(spacing: 6) {
                        // Bar
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.42, green: 0.75, blue: 0.96))
                            .frame(height: barHeight(for: day.value))
                        
                        // Day Label
                        Text(day.label)
                            .font(.caption)
                            .fontWeight(index == todayIndex ? .semibold : .regular)
                            .foregroundColor(index == todayIndex ? Color(red: 0.42, green: 0.75, blue: 0.96) : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 200)
            .padding(.top, 16)
        }
        .padding(20)
        .background(Color(.white))
        .cornerRadius(20)
//        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    private func barHeight(for value: Double) -> CGFloat {
        let maxHeight: CGFloat = 160
        let minHeight: CGFloat = 30
        return minHeight + CGFloat(value) * (maxHeight - minHeight)
    }
}

// MARK: - Preview

struct DailyActivityChart_Previews: PreviewProvider {
    static var previews: some View {
        DailyActivityChart()
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
    }
}

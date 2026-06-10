//
//  StatisticCard.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 08/06/26.
//

import SwiftUI

struct StatisticCard: View {
    
    var title: String
    var value: String
    var subtitle: String? = nil
    var trendValue: Double? = nil
    var valueColor: Color = .primary
    
    private var trendColor: Color {
        if let v = trendValue {
            return v >= 0 ? .badgeGreen : .red
        }
        return .clear
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title.bold())
                .foregroundStyle(valueColor)

            if let sub = subtitle {
                Text(sub)
                    .foregroundStyle(
                        trendValue != nil ? trendColor : .secondary
                    )
                    .font(.caption)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    StatisticCard(
        title: "Total Tasks",
        value: "56",
        subtitle: "+4 vs last week",
        trendValue: -2
    )
}

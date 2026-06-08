//
//  StatisticsView.swift
//  Homey
//
//  Placeholder until B4 builds the full statistics screen.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Statistics",
                systemImage: "chart.bar.fill",
                description: Text("Coming soon")
            )
            .navigationTitle("Statistics")
        }
    }
}

#Preview {
    StatisticsView()
}

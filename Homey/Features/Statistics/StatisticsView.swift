//
//  StatisticsView.swift
//  Homey
//
//  Full statistics screen combining StatisticCard, DailyActivity,
//  and MemberContribution components.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Statistic Cards Grid
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 12
                    ) {
                        StatisticCard(
                            title: "Total Tasks",
                            value: "56",
                            subtitle: "+4 vs last week",
                            trendValue: 4
                        )

                        StatisticCard(
                            title: "Completion Rate",
                            value: "85%",
                            subtitle: "-4% vs last week",
                            trendValue: -4
                        )

                        StatisticCard(
                            title: "On Time",
                            value: "45",
                            subtitle: "of 50 task"
                        )

                        StatisticCard(
                            title: "Overdue",
                            value: "5",
                            subtitle: nil,
                            trendValue: nil,
                            valueColor: .red
                        )
                    }
                    .padding(.horizontal)

                    // MARK: - Daily Activity Chart
                    DailyActivityChart()
                        .padding(.horizontal)

                    // MARK: - Member Contribution
                    MemberContribution()
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
//            .navigationTitle("Statistic")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
////                        dismiss()
//                    } label: {
//                        Image(systemName: "xmark")
//                    }
//                }
//            }
            .navigationToolbar(
                title: "Statistics"
            )
        }
    }
}

#Preview {
    StatisticsView()
}

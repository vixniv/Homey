//
//  StatisticsView.swift
//  Homey
//
//  Full statistics screen, driven by StatisticsViewModel.
//

import SwiftUI

struct StatisticsView: View {
    @State private var viewModel = StatisticsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 12
                    ) {
                        ForEach(viewModel.cards) { card in
                            StatisticCard(
                                title: card.title,
                                value: card.value,
                                subtitle: card.subtitle,
                                trendValue: card.trendValue,
                                valueColor: card.valueColor
                            )
                        }
                    }
                    .padding(.horizontal)

                    DailyActivityChart(data: viewModel.dailyActivity, todayIndex: viewModel.todayIndex)
                        .padding(.horizontal)

                    MemberContribution(items: viewModel.contributions)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationToolbar(title: "Statistics")
        }
        .task { await viewModel.load() }
    }
}

#Preview {
    StatisticsView()
}

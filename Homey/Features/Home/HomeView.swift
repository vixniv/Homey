//
//  HomeView.swift
//  Homey
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var selectedChore: Chore?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.monthTitle)
                    .font(.title3.weight(.semibold))

                DayStripView(
                    days: viewModel.weekDays,
                    selectedDate: viewModel.selectedDate,
                    onSelect: { viewModel.selectDate($0) }
                )

                HouseholdProgressCard(
                    householdName: viewModel.householdName,
                    memberEmojis: viewModel.members.map(\.emoji),
                    progress: viewModel.progress
                )

                HStack {
                    Text("Tasks")
                        .font(.headline)
                    Spacer()
                    Picker("Scope", selection: $viewModel.scope) {
                        ForEach(HomeViewModel.Scope.allCases, id: \.self) { scope in
                            Text(scope.rawValue).tag(scope)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 170)
                }

                if viewModel.rows.isEmpty {
                    ContentUnavailableView(
                        "No chores",
                        systemImage: "checkmark.circle",
                        description: Text("Nothing scheduled for this day.")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.rows) { task in
                            TaskCard(task: task) {
                                Task { await viewModel.grab(task) }
                            }
                            .onTapGesture {
                                selectedChore = viewModel.chore(for: task)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    Task { await viewModel.delete(task) }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
        .navigationTitle(greetingTitle)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Filter", selection: $viewModel.selectedMemberId) {
                        Text("Everyone").tag(UUID?.none)
                        ForEach(viewModel.members) { member in
                            Text("\(member.emoji) \(member.name)").tag(Optional(member.id))
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .symbolRenderingMode(.hierarchical)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: NotificationView()) {
                    Image(systemName: "bell")
                        .symbolRenderingMode(.hierarchical)
                }
            }
        }
        .fullScreenCover(item: $selectedChore) { chore in
            NavigationStack {
                DetailChoreView(chore: chore)
            }
        }
        .onAppear {
            Task { await viewModel.load() }
        }
    }

    private var greetingTitle: String {
        if let name = viewModel.currentMember?.name {
            return "Hi, \(name) 👋"
        }
        return viewModel.householdName
    }
}

#Preview {
    RootView()
}

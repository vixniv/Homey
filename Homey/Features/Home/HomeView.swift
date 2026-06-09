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

                HStack {
                    Text("Tasks")
                        .font(.headline)
                    Spacer()
                    Menu {
                        Picker("Filter", selection: $viewModel.selectedMemberId) {
                            Text("Everyone").tag(UUID?.none)
                            ForEach(viewModel.members) { member in
                                Text("\(member.emoji) \(member.name)").tag(Optional(member.id))
                            }
                        }
                    } label: {
                        Label(filterTitle, systemImage: "line.3.horizontal.decrease.circle")
                            .font(.subheadline)
                    }
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
        .refreshable {
            await viewModel.refresh()
        }
        .alert(
            "Something went wrong",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .navigationTitle(greetingTitle)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: NotificationView()) {
                    Image(systemName: "bell")
                        .symbolRenderingMode(.hierarchical)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.crop.circle")
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

    private var filterTitle: String {
        guard let id = viewModel.selectedMemberId,
              let member = viewModel.members.first(where: { $0.id == id }) else {
            return "Everyone"
        }
        return "\(member.emoji) \(member.name)"
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

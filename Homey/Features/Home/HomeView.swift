//
//  HomeView.swift
//  Homey
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var selectedChore: Chore?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MemberAvatarsList(
                        members: viewModel.members,
                        selectedMemberId: $viewModel.selectedMemberId
                    )
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's Chores")
                            .font(.title2.bold())
                        Text(viewModel.selectedDate.formatted(date: .complete, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

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
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .navigationTitle(viewModel.householdName)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: NotificationView()) {
                        Image(systemName: "bell")
                            .imageScale(.medium)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                ToolbarSpacer(placement: .topBarTrailing)
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person")
                            .imageScale(.medium)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    NavigationLink {
                        AddTaskView()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.appPrimary)
                            .clipShape(Circle())
                            .shadow(color: Color.appPrimary.opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .padding()
            .sheet(item: $selectedChore) { chore in
                DetailChoreView(chore: chore)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium, .large])
                    .interactiveDismissDisabled(false)
            }
        }
        .onAppear {
            Task { await viewModel.load() }
        }
    }
}

#Preview {
    RootView()
}

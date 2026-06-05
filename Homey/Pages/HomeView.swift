//
//  HomeScreenView.swift
//  Scoers
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct HomeView: View {

    let user = HouseholdMemberModel.mockUser
    let householdMembers = HouseholdMemberModel.mockMembers
    let date = Date()
    @State var choreViewMode: ChoreViewMode = .all
    @State private var selectedMemberId: UUID? = nil
    @State private var tasksModel = TasksModel()
    @State private var selectedTask: TaskItem? = nil

    private var visibleTasks: [TaskItem] {
        guard let selectedId = selectedMemberId else {
            return tasksModel.tasks
        }
        return tasksModel.tasks.filter { $0.assigneeId == selectedId }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MemberAvatarsList(
                        user: user,
                        householdMembers: householdMembers,
                        selectedMemberId: $selectedMemberId
                    )
                    VStack(alignment: .leading, spacing: 4){
                        Text("Today's Chores")
                            .font(.title2.bold())
                        Text(date.formatted(date: .complete, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(spacing: 12) {
                        ForEach(visibleTasks) { task in
                            TaskCard(task: task) { }
                                .onTapGesture {
                                    selectedTask = task
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        tasksModel.taskSwipedToDelete(task)
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
            .navigationTitle(Text("Ana's Family House"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "bell")
                            .imageScale(.medium)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                ToolbarSpacer(placement: .topBarTrailing)
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.medium)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .safeAreaInset(edge: .bottom){
                HStack{
                    Spacer()
                    NavigationLink{
                        AddTaskView(tasksModel: tasksModel)
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
            .sheet(item: $selectedTask) { task in
                DetailChoreView(task: task)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium, .large])
//                    .presentationBackgroundInteraction(.enabled(upThrough: .large))
                    .interactiveDismissDisabled(false)
            }
        }
    }
}

#Preview {
    ContentView()
}

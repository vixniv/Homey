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
    @State var choreViewMode: ChoreViewMode = .all

    @State private var tasksModel = TasksModel()

    private var visibleTasks: [TaskItem] {
        switch choreViewMode {
        case .all:
            return tasksModel.tasks
        case .myself:
            return tasksModel.tasks.filter { $0.assigneeId == user.id }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HeaderTitle(name: "ana")

                MemberAvatarsList(user: user, householdMembers: householdMembers)

                ProgressBar(taskCount: 20, completedTaskCount: 14)

                Text("Today's chores")
                    .font(.title)

                SegmentedControl(selection: $choreViewMode)

                List {
                    ForEach(visibleTasks) { task in
                        TaskCard(task: task) { }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    }
                    .onDelete { offsets in
                        offsets.forEach { tasksModel.taskSwipedToDelete(visibleTasks[$0]) }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)

                NavigationLink {
                    AddTaskView(tasksModel: tasksModel)
                } label: {
                    Text("+ Add task")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appPrimary)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView(selectedTabItem: .home)
}

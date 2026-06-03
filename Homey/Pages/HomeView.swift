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

                Text("Today's Chores")
                    .font(.title.bold())
                
                ProgressBar(taskCount: 27, completedTaskCount: 23)

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
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

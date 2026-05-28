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

    @State private var tasks: [TaskItem] = [
        TaskItem(title: "Wash dishes", dueLabel: "Today Before 5:00 A.M", state: .available),
        TaskItem(title: "Wash dishes", dueLabel: "Today Before 5:00 A.M", state: .inProgress, assigneeEmoji: "👱‍♀️"),
        TaskItem(title: "Wash dishes", dueLabel: "Today Before 5:00 A.M", state: .done, assigneeEmoji: "👱‍♀️")
    ]

    @State private var showAddTask = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HeaderTitle(name: "ana")

                MemberAvatarsList(user: user, householdMembers: householdMembers)

                ProgressBar(taskCount: 20, completedTaskCount: 14)

                Text("Today's chores")
                    .font(.title)

                SegmentedControl(selection: $choreViewMode)

                ScrollView {
                    ForEach($tasks) {$task in
                        TaskCard(task: task) {

                        }
                    }

                    PrimaryButton(title: "+ Add task") {
                        showAddTask = true
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding()
            .navigationDestination(isPresented: $showAddTask) {
                AddTaskView()
            }
        }
    }
}

#Preview {
    ContentView(selectedTabItem: .home)
}

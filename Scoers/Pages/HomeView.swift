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
                    ForEach(tasksModel.tasks) { task in
                        TaskCard(task: task) {

                        }
                    }

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
                .scrollIndicators(.hidden)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView(selectedTabItem: .home)
}

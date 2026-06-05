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
    @State private var selectedMemberId: UUID? = nil
    @State private var tasksModel = TasksModel()

    private var visibleTasks: [TaskItem] {
        guard let selectedId = selectedMemberId else {
            return tasksModel.tasks
        }
        return tasksModel.tasks.filter { $0.assigneeId == selectedId }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HeaderTitle(name: "ana")

                MemberAvatarsList(
                    user: user,
                    householdMembers: householdMembers,
                    selectedMemberId: $selectedMemberId
                )

                Text("Today's Chores")
                    .font(.title.bold())

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
                
                NavigationLink() {
                    AddTaskView(tasksModel: tasksModel)
                } label : {
                    HStack{
                        Spacer()
                        Image(systemName: "plus")
                            .font(.system(.title, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(15)
                            .background(Color.appPrimary)
                            .clipShape(Circle())
                    }
                    
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

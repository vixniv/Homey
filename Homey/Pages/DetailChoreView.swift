//
//  DetailChoreView.swift
//  Homey
//
//  Created by Yoram on 05/06/26.
//

import SwiftUI

struct DetailChoreView: View {
    @Environment(\.dismiss) private var dismiss

    let task: TaskItem

    // Demo data — replace with real model properties later
    private var houseName: String { "Ana's Family House" }
    private var notes: String { "Don't forget to change the bedsheets and mop the floor ya." }
    private var completedDate: Date { Date() }
    private var choreDate: Date { Date() }
    private var deadlineTime: Date { Date() }
    private var earlyNote: String? { task.state == .done ? "Done 30 min early" : nil }
    private var completedByName: String { "Ana" }
    private var completedByInitials: String { task.assigneeInitials.isEmpty ? "AN" : task.assigneeInitials }

    var body: some View {
        VStack(spacing: 0) {
            // Top navigation bar
            TopNavBar(title: "Chore Detail", leadingAction: {
                dismiss()
            })

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Chore title
                    Text(task.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.bottom, -8)

                    // House label
                    ChoreHouseLabel(houseName: houseName)

                    // Status badge
                    ChoreStatusBadge(
                        state: task.state,
                        completedDate: task.state == .done ? completedDate : nil
                    )

                    // Notes card
                    ChoreNotesCard(notes: notes)

                    // Date & deadline cards
                    HStack(spacing: 12) {
                        ChoreDateCard(date: choreDate)
                        ChoreDeadlineCard(
                            deadlineTime: deadlineTime,
                            earlyNote: earlyNote
                        )
                    }

                    // Completed by card (only for done tasks)
                    if task.state == .done {
                        ChoreCompletedByCard(
                            memberName: completedByName,
                            memberInitials: completedByInitials,
                            subtitle: "Finished the task"
                        )
                    }
                    
                    ChoreAssigneeCard(
                        memberName: "Mom",
                        memberInitials: "MO",
                        subtitle: "Primary asignee"
                    )
                    
                    PrimaryButton(title: "Grab this chore"){}
                        .padding(.top, 16)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        DetailChoreView(
            task: TaskItem(
                title: "Clean the bathroom",
                dueLabel: "Today Before 5:00 A.M",
                state: .done,
                assigneeInitials: "MO"
            )
        )
    }
}

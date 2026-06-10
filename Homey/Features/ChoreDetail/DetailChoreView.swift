//
//  DetailChoreView.swift
//  Homey
//

import SwiftUI

struct DetailChoreView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ChoreDetailViewModel
    @State private var isEditing = false

    init(chore: Chore, date: Date? = nil) {
        _viewModel = State(initialValue: ChoreDetailViewModel(chore: chore, date: date))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.chore.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.bottom, -8)

                ChoreHouseLabel(houseName: viewModel.householdName)

                ChoreStatusBadge(
                    state: viewModel.state,
                    completedDate: viewModel.completion?.completedAt
                )

                if !viewModel.chore.notes.isEmpty {
                    ChoreNotesCard(notes: viewModel.chore.notes)
                }

                HStack(spacing: 12) {
                    ChoreDateCard(date: viewModel.chore.dueDate)
                    ChoreDeadlineCard(
                        deadlineTime: viewModel.chore.dueDate,
                        earlyNote: nil
                    )
                }

                if viewModel.state == .done, let completedBy = viewModel.completedBy {
                    ChoreCompletedByCard(
                        memberName: completedBy.name,
                        memberInitials: completedBy.emoji,
                        subtitle: "Finished the task"
                    )
                }

                if let assignee = viewModel.assignee {
                    ChoreAssigneeCard(
                        memberName: assignee.name,
                        memberInitials: assignee.emoji,
                        subtitle: "Primary assignee"
                    )
                }

                if viewModel.state != .done {
                    PrimaryButton(
                        title: viewModel.state == .available ? "Grab this chore" : "Mark as done"
                    ) {
                        Task {
                            await viewModel.primaryAction()
                            dismiss()
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle("Chore Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { isEditing = true }
            }
        }
        .task { await viewModel.load() }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                TaskFormView(mode: .edit(viewModel.chore))
            }
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
    }
}

#Preview {
    NavigationStack {
        DetailChoreView(
            chore: Chore(
                id: UUID(),
                householdId: UUID(),
                title: "Clean the bathroom",
                notes: "Don't forget the bedsheets.",
                assigneeId: nil,
                dueDate: Date(),
                status: .available
            )
        )
    }
}

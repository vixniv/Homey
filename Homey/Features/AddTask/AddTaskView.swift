//
//  AddTaskView.swift
//  Homey
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AddTaskViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TextInputField(choreTitle: $viewModel.title)
                    .padding(.bottom, 10)

                Deadline(
                    selectedDate: $viewModel.date,
                    selectedTime: $viewModel.time
                )
                .padding(.bottom, 10)

                InstructionInput()
                    .padding(.bottom, 10)

                assignToSection
                    .padding(.bottom, 10)

                PrimaryButton(
                    title: "Create Task",
                    color: .appSecondary,
                    action: createTask
                )
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.vertical, 16)
        }
        .navigationToolbar(title: "Add Task")
        .task { await viewModel.load() }
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

    private var assignToSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Assign to")
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal)
                .padding(.bottom, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                MemberAvatarsList(
                    members: viewModel.members,
                    showDivider: false,
                    selectedMemberId: $viewModel.assigneeId
                )
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func createTask() {
        Task {
            if await viewModel.create() {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddTaskView()
    }
}

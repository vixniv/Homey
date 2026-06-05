//
//  AddTaskView.swift
//  Scoers
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss

    let tasksModel: TasksModel

    @State private var task: TaskModel = {
        var model = TaskModel()
        model.assigneeId = nil
        return model
    }()

    private let allMembers = HouseholdMemberModel.mockMembers

    let onBack: (() -> Void)? = nil

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TextInputField(choreTitle: $task.title)
                        .padding(.bottom, 10)

                    Deadline(
                        selectedDate: .constant(Date()),
                        selectedTime: .constant(Date())
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
            .navigationToolbar(
                title: "Add Task",
                leadingAction: { onBack?() }
            )
        }

    private var assignToSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Assign to")
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal)
                .padding(.bottom, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                MemberAvatarsList(
                    user: HouseholdMemberModel.mockUser,
                    householdMembers: allMembers,
                    showDivider: false,
                    selectedMemberId: Binding(
                        get: { task.assigneeId },
                        set: { task.assigneeId = $0 }
                    )
                )
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func createTask() {
        tasksModel.createTaskButtonTapped(form: task)
        dismiss()
    }
}

#Preview {
    AddTaskView(tasksModel: TasksModel())
}

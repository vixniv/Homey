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
        model.assigneeId = HouseholdMemberModel.mockUser.id
        return model
    }()

    private let allMembers = HouseholdMemberModel.mockMembers

    var body: some View {
        VStack(spacing: 0) {
            TopNavigationBar(title: "Add Task") {
                dismiss()
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TextInputField(choreTitle: $task.title)

                    PhotoPickerField(photoData: $task.photoData)

                    DatePickerField(selectedDate: $task.date)

                    VStack(alignment: .leading, spacing: 8) {
                        TimePicker(selectedTime: $task.time)
                        infoBullets
                    }

                    InstructionSegment(selection: $task.instructionType)

                    instructionContent

                    assignToSection

                    PrimaryButton(title: "Create Task", color: .appSecondary, action: createTask)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
                .padding(.vertical, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private var instructionContent: some View {
        switch task.instructionType {
        case .voiceNote:
            VoiceNotePlaceholder(color: Color.appPrimary)
        case .notes:
            VStack(alignment: .leading, spacing: 6) {
                TextField("Type your notes…", text: $task.notes, axis: .vertical)
                    .lineLimit(3...6)
                    .font(.system(size: 16, weight: .regular))
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appPrimary))
            }
            .padding(.horizontal)
        }
    }

    private var infoBullets: some View {
        VStack(alignment: .leading, spacing: 4) {
            bullet("Reminder sent 3 hours before")
            bullet("Auto-assign 2 hours before")
        }
        .padding(.horizontal)
    }

    private func bullet(_ text: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.appPrimary)
                .frame(width: 6, height: 6)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }

    private var assignToSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Assign to")
                .font(.system(size: 14, weight: .regular))
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(allMembers) { member in
                        MemberAvatarItemSelectable(
                            householdMember: member,
                            isSelected: Binding(
                                get: { task.assigneeId == member.id },
                                set: { _ in }
                            ),
                            action: { task.assigneeId = member.id }
                        )
                    }
                }
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
    NavigationStack {
        AddTaskView(tasksModel: TasksModel())
    }
}

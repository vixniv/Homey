//
//  TaskFormView.swift
//  Homey

import SwiftUI

struct TaskFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: TaskFormViewModel

    init(mode: TaskFormViewModel.Mode = .create) {
        _viewModel = State(initialValue: TaskFormViewModel(mode: mode))
    }

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

                recurrenceSection
                    .padding(.bottom, 10)

                InstructionInput(text: $viewModel.notes)
                    .padding(.bottom, 10)

                assignToSection
                    .padding(.bottom, 10)

                PrimaryButton(
                    title: viewModel.ctaTitle,
                    color: .appSecondary,
                    action: save
                )
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.vertical, 16)
        }
        .navigationToolbar(title: viewModel.navTitle)
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

    private var recurrenceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Repeat")
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal)

            Picker("Repeat", selection: $viewModel.recurrence) {
                Text("Once").tag(Recurrence.once)
                Text("Daily").tag(Recurrence.daily)
                Text("Weekly").tag(Recurrence.weekly)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if viewModel.recurrence == .weekly {
                DaySelector(selected: $viewModel.recurrenceDays)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func save() {
        Task {
            if await viewModel.save() {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        TaskFormView()
    }
}

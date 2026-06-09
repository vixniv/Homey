//
//  Deadline.swift
//  Homey
//
//  Created by Yoram on 04/06/26.
//

import SwiftUI

struct Deadline: View {
    @Binding var selectedDate: Date
    @Binding var selectedTime: Date

    // MARK: - Formatters

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium   // e.g. "Apr 1, 2025"
        f.timeStyle = .none
        return f
    }

    private var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short    // e.g. "9:41 AM"
        return f
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Date and deadline")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.22))

            // Date + Time pills
            HStack(spacing: 12) {
                DatePill(label: dateFormatter.string(from: selectedDate), current: selectedDate) {
                    selectedDate = $0
                }

                TimePill(label: timeFormatter.string(from: selectedTime), current: selectedTime) {
                    selectedTime = $0
                }
            }

        }
        .padding(.horizontal)
    }
}

// MARK: - Date Pill

private struct DatePill: View {
    let label: String
    let current: Date
    let onSelect: (Date) -> Void

    @State private var showPicker = false
    @State private var draft: Date = Date()

    var body: some View {
        Button {
            draft = current
            showPicker = true
        } label: {
            Text(label)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
        }
        .sheet(isPresented: $showPicker) {
            DatePickerSheet(
                mode: .date,
                selection: $draft,
                onDone: {
                    onSelect(draft)
                    showPicker = false
                },
                onCancel: { showPicker = false }
            )
        }

    }
}

// MARK: - Time Pill

private struct TimePill: View {
    let label: String
    let current: Date
    let onSelect: (Date) -> Void

    @State private var showPicker = false
    @State private var draft: Date = Date()

    var body: some View {
        Button {
            draft = current
            showPicker = true
        } label: {
            Text(label)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
        }
        .sheet(isPresented: $showPicker) {
            DatePickerSheet(
                mode: .time,
                selection: $draft,
                onDone: {
                    onSelect(draft)
                    showPicker = false
                },
                onCancel: { showPicker = false }
            )
        }

        
    }
}

// MARK: - Shared picker sheet

private struct DatePickerSheet: View {
    enum Mode { case date, time }

    let mode: Mode
    @Binding var selection: Date
    let onDone: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            pickerView
                .labelsHidden()
                .padding()
                .navigationTitle(mode == .date ? "Pick a Date" : "Pick a Time")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: onCancel)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", action: onDone)
                            .fontWeight(.semibold)
                    }
                }
        }
        .presentationDetents([.medium])
    }

    @ViewBuilder
    private var pickerView: some View {
        if mode == .date {
            SwiftUI.DatePicker("", selection: $selection, displayedComponents: .date)
                .datePickerStyle(.graphical)
        } else {
            SwiftUI.DatePicker("", selection: $selection, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
        }
    }
}

// MARK: - Preview

#Preview {
    Deadline(
        selectedDate: .constant(Date()),
        selectedTime: .constant(Date())
    )
    .padding()
}


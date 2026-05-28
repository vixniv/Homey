//
//  TasksModel.swift
//  Scoers
//

import Foundation

@Observable
final class TasksModel {
    var tasks: [TaskItem]

    init() {
        tasks = [
            TaskItem(title: "Wash dishes", dueLabel: "Today Before 5:00 A.M", state: .available),
            TaskItem(title: "Take out the trash", dueLabel: "Today Before 8:00 P.M", state: .inProgress, assigneeEmoji: "👱‍♀️"),
            TaskItem(title: "Vacuum the living room", dueLabel: "Yesterday", state: .done, assigneeEmoji: "👱‍♀️")
        ]
    }

    func createTaskButtonTapped(form: TaskModel) {
        let task = TaskItem(
            title: form.title,
            dueLabel: Self.formatDueLabel(date: form.date, time: form.time)
        )
        tasks.insert(task, at: 0)
    }

    private static func formatDueLabel(date: Date, time: Date) -> String {
        let calendar = Calendar.current
        let dayLabel: String
        if calendar.isDateInToday(date) {
            dayLabel = "Today"
        } else if calendar.isDateInTomorrow(date) {
            dayLabel = "Tomorrow"
        } else {
            let df = DateFormatter()
            df.dateFormat = "dd MMM"
            dayLabel = df.string(from: date)
        }
        let tf = DateFormatter()
        tf.dateFormat = "h:mm a"
        return "\(dayLabel) Before \(tf.string(from: time))"
    }
}

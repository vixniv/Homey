//
//  TasksModel.swift
//  Scoers
//

import Foundation

@Observable
final class TasksModel {
    var tasks: [TaskItem]

    init() {
        let user = HouseholdMemberModel.mockUser
        let others = HouseholdMemberModel.mockMembers.filter { $0.id != user.id }
        tasks = [
            TaskItem(title: "Wash dishes", dueLabel: "Today Before 5:00 A.M", state: .available, assigneeId: user.id),
            TaskItem(title: "Take out the trash", dueLabel: "Today Before 8:00 P.M", state: .inProgress, assigneeId: others.first?.id),
            TaskItem(title: "Vacuum the living room", dueLabel: "Yesterday", state: .done, assigneeId: others.first?.id)
        ]
    }

    func createTaskButtonTapped(form: TaskModel) {
        let task = TaskItem(
            title: form.title,
            dueLabel: Self.formatDueLabel(date: form.date, time: form.time),
            assigneeId: form.assigneeId
        )
        tasks.insert(task, at: 0)
    }

    func taskSwipedToDelete(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
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

//
//  TasksModel.swift
//  Scoers
//

import Foundation

@Observable
final class TasksModel {
    
    private static func initials(from member: HouseholdMemberModel?) -> String {
        guard let nickname = member?.nickname else { return "" }
        return String(nickname.prefix(2)).uppercased()
    }
    
    var tasks: [TaskItem]

    init() {
        let user = HouseholdMemberModel.mockUser
        let others = HouseholdMemberModel.mockMembers.filter { $0.id != user.id }
        let firstOther = others.first
        tasks = [
            TaskItem(id: UUID(), title: "Clean bathroom", dueLabel: "Before 5:00 A.M", state: .available, assigneeInitials: Self.initials(from: user),
                     assigneeId: user.id),
            TaskItem(id: UUID(), title: "Wash dishes", dueLabel: "Before 8:00 P.M", state: .inProgress, assigneeInitials: Self.initials(from: firstOther),
                     assigneeId: firstOther?.id),
            TaskItem(id: UUID(), title: "Mop the floor", dueLabel: "Before 9:00 P.M", state: .done, assigneeInitials: Self.initials(from: firstOther),
                     assigneeId: firstOther?.id),
            TaskItem(id: UUID(), title: "Vacuum the living room", dueLabel: "Before 2:00 P.M", state: .late, assigneeInitials: Self.initials(from: firstOther),assigneeId: firstOther?.id)
        ]
    }

    func createTaskButtonTapped(form: TaskModel) {
        let allMembers = HouseholdMemberModel.mockMembers
        let assignee = allMembers.first { $0.id == form.assigneeId }
        let task = TaskItem(
            id: UUID(),
            title: form.title,
            dueLabel: Self.formatDueLabel(date: form.date, time: form.time),
            state: form.assigneeId != nil ? .inProgress : .available,
            assigneeInitials: Self.initials(from: assignee),
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

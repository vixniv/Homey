import SwiftUI

// MARK: - task state

enum TaskState {
    case available
    case inProgress
    case done
}

// MARK: - task model

struct TaskItem: Identifiable {
    let id = UUID()
    var title: String
    var dueLabel: String
    var state: TaskState = .available
    var assigneeEmoji: String = "👱‍♀️"
    var assigneeId: UUID? = nil
}

// MARK: - task card view

struct TaskCard: View {
    let task: TaskItem
    let onGrab: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // left content
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(task.state == .done ? .secondary : .primary)
                    .strikethrough(task.state == .done, color: .secondary)

                Text("Due : \(task.dueLabel)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // right action area
            switch task.state {
            case .available:
                GrabButton(action: onGrab)
            case .inProgress:
                InProgressBadge(emoji: task.assigneeEmoji)
            case .done:
                DoneBadge(emoji: task.assigneeEmoji)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            task.state == .done
                ? Color(.systemBackground).opacity(0.6)
                : Color(.systemBackground)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(borderColor, lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private var borderColor: Color {
        switch task.state {
        case .available: return Color.blue.opacity(0.35)
        case .inProgress: return Color.blue.opacity(0.35)
        case .done: return Color.green.opacity(0.35)
        }
    }
}

// MARK: - grab button

struct GrabButton: View {
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text("Grab it")
                    .font(.system(size: 16, weight: .semibold))
                Text("👆")
                    .font(.system(size: 16))
            }
            .foregroundColor(.black)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                Color(red: 124/255, green: 196/255, blue: 240/255)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - in progress badge

struct InProgressBadge: View {
    let emoji: String

    var body: some View {
        HStack(spacing: 10) {
            // assignee avatar circle
            ZStack {
                Circle()
                    .strokeBorder(Color.blue.opacity(0.25), lineWidth: 1.5)
                    .background(Circle().fill(Color.blue.opacity(0.06)))
                    .frame(width: 44, height: 44)
                Text(emoji)
                    .font(.system(size: 24))
            }

            // status pill
            Text("On Progress")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.blue.opacity(0.7))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - done badge

struct DoneBadge: View {
    let emoji: String
    
    var body: some View {
        HStack(spacing: 8) {
            // assignee avatar circle
            ZStack {
                Circle()
                    .strokeBorder(Color.blue.opacity(0.25), lineWidth: 1.5)
                    .background(Circle().fill(Color.blue.opacity(0.06)))
                    .frame(width: 44, height: 44)
                Text(emoji)
                    .font(.system(size: 24))
            }

            // done pill
            Text("Done")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.green.opacity(0.75))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.green.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.green.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - preview

struct TaskCardDemoView: View {
    @State private var tasks: [TaskItem] = [
        TaskItem(title: "Wash dishes", dueLabel: "Today Before 5:00 A.M", state: .available),
        TaskItem(title: "Wash dishes", dueLabel: "Today Before 5:00 A.M", state: .inProgress, assigneeEmoji: "👱‍♀️"),
        TaskItem(title: "Wash dishes", dueLabel: "Today Before 5:00 A.M", state: .done, assigneeEmoji: "👱‍♀️")
    ]

    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.96, blue: 0.97)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ForEach($tasks) { $task in
                    TaskCard(task: task) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            task.state = .inProgress
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    TaskCardDemoView()
}

#Preview {
    ContentView(selectedTabItem: .home)
}

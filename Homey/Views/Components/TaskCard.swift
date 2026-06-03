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
    var assigneeEmoji: String = "👱🏻‍♀️"
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
                    .foregroundColor(textColor)
                    .strikethrough(task.state == .done, color: textColor)

                Text("Due : \(task.dueLabel)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(textColor)
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
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    private var backgroundColor: Color {
        switch task.state {
        case .available: return .taskBlue
        case .inProgress: return .taskYellow
        case .done: return .taskGreen
        }
    }
        
    private var textColor: Color {
        switch task.state {
        case .available: return .textBlue
        case .inProgress: return .textYellow
        case .done: return .textGreen
        }
    }
}

// MARK: - grab button

struct GrabButton: View {
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text("Grab it")
                    .font(.system(size: 16, weight: .medium))
                Image(systemName: "hand.tap")
                    .font(.system(size: 16))
            }
            .foregroundColor(Color(red: 45/255, green: 114/255, blue: 178/255))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(Capsule())
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .overlay(
                Capsule()
                    .stroke(Color(red: 45/255, green: 114/255, blue: 178/255), lineWidth: 1)
            )
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
                    .strokeBorder(Color.badgeYellow)
                    .background(Circle().fill(Color.white))
                    .frame(width: 44, height: 44)
                Text(emoji)
                    .font(.system(size: 24))
            }

            // status pill
            Text("In Progress")
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .background(Color.badgeYellow)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
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
                    .strokeBorder(Color.badgeGreen)
                    .background(Circle().fill(Color.white))
                    .frame(width: 44, height: 44)
                Text(emoji)
                    .font(.system(size: 24))
            }

            // done pill
            Text("Done")
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.white)
                .background(Color.badgeGreen)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
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
        TaskItem(title: "Clean bathroom", dueLabel: "Today Before 5:00 A.M", state: .inProgress, assigneeEmoji: "👱‍♀️"),
        TaskItem(title: "Mop the floor", dueLabel: "Today Before 5:00 A.M", state: .done, assigneeEmoji: "👱‍♀️")
    ]

    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()

            VStack(spacing: 14) {
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

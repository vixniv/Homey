import SwiftUI

// MARK: - task state

enum TaskState {
    case available
    case inProgress
    case done
    case late
}

// MARK: - task model

struct TaskItem: Identifiable {
    let id: String                 // occurrence id (choreId, or "choreId-yyyy-MM-dd")
    let choreId: UUID
    let occurrenceDate: Date?      // nil = one-off chore
    var title: String
    var dueLabel: String
    var state: TaskState = .available
    var assigneeInitials: String = ""
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
                HStack(spacing: 8){
                    Text(task.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(textColor)
                    Group {
                            switch task.state {
                            case .inProgress:
                                InProgressBadge()
                            case .done:
                                DoneBadge()
                            case .available:
                                EmptyView()
                            case .late:
                                LateBadge()
                            }
                        }
                }
                HStack{
                    switch task.state {
                    case .inProgress:
                        Image(systemName: "clock")
                            .foregroundStyle(Color.textYellow)
                    case .done:
                        Image(systemName: "clock")
                            .foregroundStyle(Color.textGreen)
                    case .available:
                        Image(systemName: "clock")
                            .foregroundStyle(Color.textBlue)
                    case .late:
                        Image(systemName: "exclamationmark.circle")
                            .foregroundStyle(Color.textRed)
                    }
                    Text(task.dueLabel)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(textColor)
                }
            }
            Spacer()
            switch task.state {
            case .available:
                GrabButton(action: onGrab)
            case .inProgress:
                Text(task.assigneeInitials)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 45, height: 45)
                    .background(
                        Circle()
                            .fill(Color.white)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.textYellow)
                        )
                
            case .done:
                HStack{
                    Image(systemName: "camera.badge.clock")
                        .foregroundStyle(Color.textGreen)
                        .frame(width: 35, height: 35)
                        .background(
                            Circle()
                                .stroke(Color.textGreen, lineWidth: 1)
                            )
                        .padding(.horizontal, 3)
                    Text(task.assigneeInitials)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 45, height: 45)
                        .background(
                            Circle()
                                .fill(Color.white)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color(red: 0.45, green: 0.82, blue: 0.71), lineWidth: 2)
                            )
                }
                
            case .late:
                Text(task.assigneeInitials)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 45, height: 45)
                    .background(
                        Circle()
                            .fill(Color.white)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.textRed)
                        )
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
        case .late: return .taskRed
        }
    }
        
    private var textColor: Color {
        switch task.state {
        case .available: return .textBlue
        case .inProgress: return .textYellow
        case .done: return .textGreen
        case .late: return .textRed
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
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(.appPrimary)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous))
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
    var body: some View {
        HStack(spacing: 10) {
            Text("In Progress")
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.textYellow)
                .background(Color.taskYellow)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.textYellow)
                )
                
            
        }
    }
}

// MARK: - avatar
struct Avatar: View {
    let emoji: String
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.badgeYellow)
                .background(Circle().fill(Color.white))
                .frame(width: 44, height: 44)
            Text(emoji)
                .font(.system(size: 24))
        }
    }
}

// MARK: - done badge

struct DoneBadge: View {
    var body: some View {
        HStack(spacing: 8) {
            Text("Done")
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color.textGreen)
                .background(Color.taskGreen)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.textGreen)
                )
        }
    }
}

// MARK: - late badge

struct LateBadge: View {
    var body: some View {
        HStack(spacing: 10) {
            Text("Late")
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.textRed)
                .background(Color.taskRed)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.textRed)
                )
                
            
        }
    }
}

// MARK: - camerabutton
struct CameraButton: View {
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.badgeGreen)
                .background(Circle().fill(Color.white))
                .frame(width: 40, height: 40)
            Image(systemName: "camera.badge.clock")
                .font(.system(size: 16))
                .foregroundColor(Color.badgeGreen)
        }
    }
}

// MARK: - preview

struct TaskCardDemoView: View {
    @State private var tasks: [TaskItem] = [
        TaskItem(id: "1", choreId: UUID(), occurrenceDate: nil, title: "Wash dishes", dueLabel: "Before 5:00 A.M", state: .available),
        TaskItem(id: "2", choreId: UUID(), occurrenceDate: nil, title: "Clean bathroom", dueLabel: "Before 5:00 A.M", state: .inProgress, assigneeInitials: "MO"),
        TaskItem(id: "3", choreId: UUID(), occurrenceDate: nil, title: "Mop the floor", dueLabel: "Before 5:00 A.M", state: .done, assigneeInitials: "AN"),
        TaskItem(id: "4", choreId: UUID(), occurrenceDate: nil, title: "Mop the floor", dueLabel: "Before 5:00 A.M", state: .late, assigneeInitials: "AN")
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
    RootView()
}

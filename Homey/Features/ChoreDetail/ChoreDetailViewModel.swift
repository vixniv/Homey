//
//  ChoreDetailViewModel.swift
//  Homey
//

import Dependencies
import Foundation
import Observation

@MainActor
@Observable
final class ChoreDetailViewModel {
    @ObservationIgnored @Dependency(\.choreClient) private var choreClient
    @ObservationIgnored @Dependency(\.householdClient) private var householdClient
    @ObservationIgnored @Dependency(\.date.now) private var now

    let chore: Chore
    var householdName = ""
    var assignee: Member?
    var completedBy: Member?
    var completion: ChoreCompletion?
    var errorMessage: String?

    init(chore: Chore) {
        self.chore = chore
    }

    var state: TaskState {
        if chore.status == .done { return .done }
        if chore.dueDate < now { return .late }
        if chore.status == .inProgress { return .inProgress }
        return .available
    }

    func load() async {
        do {
            async let household = householdClient.household()
            async let members = householdClient.members()
            async let completions = choreClient.completions()

            householdName = try await household.name
            let memberList = try await members
            let completionList = try await completions

            assignee = memberList.first { $0.id == chore.assigneeId }
            completion = completionList.first { $0.choreId == chore.id }
            completedBy = memberList.first { $0.id == completion?.completedBy }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func primaryAction() async {
        do {
            let me = try await householdClient.currentMemberId()
            switch state {
            case .available:
                try await choreClient.grab(choreId: chore.id, by: me)
            case .inProgress, .late:
                try await choreClient.finish(choreId: chore.id, by: me, at: now)
            case .done:
                break
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

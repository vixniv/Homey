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

    init(chore: Chore) {
        self.chore = chore
    }

    var state: TaskState {
        if chore.status == .done { return .done }
        if chore.dueDate < now { return .late }
        if chore.status == .inProgress || chore.status == .assigned { return .inProgress }
        return .available
    }

    func load() async {
        async let household = householdClient.household()
        async let members = householdClient.members()
        async let completions = choreClient.completions()

        householdName = await household.name
        let memberList = await members
        let completionList = await completions

        assignee = memberList.first { $0.id == chore.assigneeId }
        completion = completionList.first { $0.choreId == chore.id }
        completedBy = memberList.first { $0.id == completion?.completedBy }
    }

    func primaryAction() async {
        let me = await householdClient.currentMemberId()
        switch state {
        case .available:
            await choreClient.grab(chore.id, me)
        case .inProgress, .late:
            await choreClient.finish(chore.id, me, now)
        case .done:
            break
        }
    }
}

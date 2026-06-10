//
//  Occurrence.swift
//  Homey
//
//  A resolved, renderable task instance for a given day. Computed by
//  HouseholdStore (one-off chore or a recurring template's day). Not persisted.
//

import Foundation

struct Occurrence: Identifiable, Hashable {
    let chore: Chore
    let date: Date          // start of day
    let dueDate: Date       // date + the template's time-of-day
    var status: ChoreStatus
    var assigneeId: UUID?
    var isRecurring: Bool

    var id: String {
        isRecurring ? "\(chore.id.uuidString)-\(HouseholdStore.dayKey(date))" : chore.id.uuidString
    }
}

//
//  HouseholdStore.swift
//  Homey
//
//  Single in-memory source of truth observed by every screen. Mutations are
//  applied locally first (optimistic), pushed to Supabase via the clients, and
//  rolled back on error.
//

import Dependencies
import Foundation
import Observation

@MainActor
@Observable
final class HouseholdStore {
    @ObservationIgnored @Dependency(\.choreClient) private var choreClient
    @ObservationIgnored @Dependency(\.householdClient) private var householdClient

    var householdId: UUID?
    var householdName = ""
    var inviteCode: String?
    var inviteExpiresAt: Date?
    var members: [Member] = []
    var chores: [Chore] = []
    var completions: [ChoreCompletion] = []
    var occurrences: [ChoreOccurrence] = []   // per-day overrides for recurring chores
    var currentMemberId: UUID?
    var isLoading = false
    var errorMessage: String?

    nonisolated init() {}

    private let calendar = Calendar(identifier: .gregorian)

    // MARK: - Day key

    @ObservationIgnored private static let dayKeyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    static func dayKey(_ date: Date) -> String { dayKeyFormatter.string(from: date) }

    // MARK: - Load

    func load() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            async let householdTask = householdClient.household()
            async let membersTask = householdClient.members()
            async let currentMemberTask = householdClient.currentMemberId()
            async let choresTask = choreClient.allChores()
            async let completionsTask = choreClient.completions()
            async let occurrencesTask = choreClient.allOccurrences()

            let household = try await householdTask
            householdId = household.id
            householdName = household.name
            inviteCode = household.inviteCode
            inviteExpiresAt = household.inviteExpiresAt
            members = try await membersTask
            currentMemberId = try await currentMemberTask
            chores = (try await choresTask).sorted { $0.dueDate < $1.dueDate }
            completions = try await completionsTask
            occurrences = try await occurrencesTask
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func generateInviteCode() async {
        guard let id = householdId else { return }
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            let newCode = try await householdClient.generateInviteCode(householdId: id)
            self.inviteCode = newCode
            self.inviteExpiresAt = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Occurrence engine

    /// Resolved occurrences to render for a given day (one-off + recurring).
    func occurrences(on day: Date) -> [Occurrence] {
        let target = calendar.startOfDay(for: day)
        var result: [Occurrence] = []
        for chore in chores {
            switch chore.recurrence {
            case .once:
                if calendar.startOfDay(for: chore.dueDate) == target {
                    result.append(Occurrence(
                        chore: chore, date: target, dueDate: chore.dueDate,
                        status: chore.status, assigneeId: chore.assigneeId, isRecurring: false
                    ))
                }
            case .daily, .weekly:
                if matches(chore, on: target) {
                    result.append(resolvedRecurring(chore, on: target))
                }
            }
        }
        return result.sorted { $0.dueDate < $1.dueDate }
    }

    /// Resolved occurrence for the detail screen. `date == nil` => one-off chore.
    func resolvedOccurrence(choreId: UUID, on date: Date?) -> Occurrence? {
        guard let chore = chores.first(where: { $0.id == choreId }) else { return nil }
        guard let date else {
            return Occurrence(chore: chore, date: calendar.startOfDay(for: chore.dueDate),
                              dueDate: chore.dueDate, status: chore.status,
                              assigneeId: chore.assigneeId, isRecurring: false)
        }
        return resolvedRecurring(chore, on: calendar.startOfDay(for: date))
    }

    private func matches(_ chore: Chore, on day: Date) -> Bool {
        guard day >= calendar.startOfDay(for: chore.dueDate) else { return false }
        switch chore.recurrence {
        case .once: return false
        case .daily: return true
        case .weekly:
            let weekdayIndex = calendar.component(.weekday, from: day) - 1  // 0=Sun…6=Sat
            return chore.recurrenceDays.contains(weekdayIndex)
        }
    }

    private func resolvedRecurring(_ chore: Chore, on day: Date) -> Occurrence {
        let key = Self.dayKey(day)
        let override = occurrences.first { $0.choreId == chore.id && $0.occurrenceDate == key }
        let doneByCompletion = completions.contains {
            $0.choreId == chore.id && Self.dayKey($0.completedAt) == key
        }
        let status = override?.status ?? (doneByCompletion ? .done : .available)
        let assigneeId = override?.assigneeId ?? chore.assigneeId
        return Occurrence(
            chore: chore, date: day, dueDate: combine(day: day, time: chore.dueDate),
            status: status, assigneeId: assigneeId, isRecurring: true
        )
    }

    private func combine(day: Date, time: Date) -> Date {
        let d = calendar.dateComponents([.year, .month, .day], from: day)
        let t = calendar.dateComponents([.hour, .minute], from: time)
        var c = DateComponents()
        c.year = d.year; c.month = d.month; c.day = d.day; c.hour = t.hour; c.minute = t.minute
        return calendar.date(from: c) ?? day
    }

    // MARK: - Mutations (optimistic + rollback)

    func create(_ chore: Chore) async {
        errorMessage = nil
        let snapshot = chores
        chores.append(chore)
        chores.sort { $0.dueDate < $1.dueDate }
        do { try await choreClient.create(chore) }
        catch { chores = snapshot; errorMessage = error.localizedDescription }
    }

    func update(_ chore: Chore) async {
        errorMessage = nil
        let snapshot = chores
        guard let i = chores.firstIndex(where: { $0.id == chore.id }) else { return }
        chores[i] = chore
        chores.sort { $0.dueDate < $1.dueDate }
        do { try await choreClient.update(chore) }
        catch { chores = snapshot; errorMessage = error.localizedDescription }
    }

    func delete(choreId: UUID) async {
        errorMessage = nil
        let choresSnap = chores
        let completionsSnap = completions
        let occurrencesSnap = occurrences
        chores.removeAll { $0.id == choreId }
        completions.removeAll { $0.choreId == choreId }
        occurrences.removeAll { $0.choreId == choreId }
        do { try await choreClient.delete(choreId: choreId) }
        catch {
            chores = choresSnap; completions = completionsSnap; occurrences = occurrencesSnap
            errorMessage = error.localizedDescription
        }
    }

    /// `on: nil` => one-off chore; otherwise a recurring occurrence on that day.
    func grab(choreId: UUID, by memberId: UUID, on occurrenceDate: Date? = nil) async {
        errorMessage = nil
        guard let occurrenceDate else {
            let snapshot = chores
            guard let i = chores.firstIndex(where: { $0.id == choreId }) else { return }
            chores[i].assigneeId = memberId
            chores[i].status = .inProgress
            do { try await choreClient.grab(choreId: choreId, by: memberId) }
            catch { chores = snapshot; errorMessage = error.localizedDescription }
            return
        }
        let snapshot = occurrences
        let occ = makeOverride(choreId: choreId, day: occurrenceDate, status: .inProgress, assigneeId: memberId)
        applyOverride(occ)
        do { try await choreClient.upsertOccurrence(occ) }
        catch { occurrences = snapshot; errorMessage = error.localizedDescription }
    }

    /// `on: nil` => one-off chore; otherwise a recurring occurrence on that day.
    func finish(choreId: UUID, by memberId: UUID, at date: Date, on occurrenceDate: Date? = nil) async {
        errorMessage = nil
        guard let occurrenceDate else {
            let choresSnap = chores
            let completionsSnap = completions
            guard let i = chores.firstIndex(where: { $0.id == choreId }) else { return }
            chores[i].status = .done
            completions.append(ChoreCompletion(id: UUID(), choreId: choreId, completedBy: memberId, completedAt: date))
            do { try await choreClient.finish(choreId: choreId, by: memberId, at: date) }
            catch { chores = choresSnap; completions = completionsSnap; errorMessage = error.localizedDescription }
            return
        }
        let occSnap = occurrences
        let compSnap = completions
        // Attribute the completion to the occurrence's day (not `now`), so finishing a
        // past/future day this week doesn't bleed "done" onto today's occurrence.
        let stamp = calendar.startOfDay(for: occurrenceDate)
        let existingAssignee = occurrences.first { $0.choreId == choreId && $0.occurrenceDate == Self.dayKey(occurrenceDate) }?.assigneeId
        let occ = makeOverride(choreId: choreId, day: occurrenceDate, status: .done, assigneeId: existingAssignee ?? memberId)
        applyOverride(occ)
        completions.append(ChoreCompletion(id: UUID(), choreId: choreId, completedBy: memberId, completedAt: stamp))
        do {
            try await choreClient.upsertOccurrence(occ)
            try await choreClient.finish(choreId: choreId, by: memberId, at: stamp)
        } catch {
            occurrences = occSnap; completions = compSnap; errorMessage = error.localizedDescription
        }
    }

    // MARK: - Override helpers

    private func makeOverride(choreId: UUID, day: Date, status: ChoreStatus, assigneeId: UUID?) -> ChoreOccurrence {
        let key = Self.dayKey(day)
        let existingId = occurrences.first { $0.choreId == choreId && $0.occurrenceDate == key }?.id
        return ChoreOccurrence(id: existingId ?? UUID(), choreId: choreId, occurrenceDate: key, assigneeId: assigneeId, status: status)
    }

    private func applyOverride(_ occ: ChoreOccurrence) {
        if let i = occurrences.firstIndex(where: { $0.choreId == occ.choreId && $0.occurrenceDate == occ.occurrenceDate }) {
            occurrences[i] = occ
        } else {
            occurrences.append(occ)
        }
    }
}

// MARK: - Dependency

private enum HouseholdStoreKey: DependencyKey {
    static let liveValue = HouseholdStore()
    static var previewValue: HouseholdStore { liveValue }
}

extension DependencyValues {
    var householdStore: HouseholdStore {
        get { self[HouseholdStoreKey.self] }
        set { self[HouseholdStoreKey.self] = newValue }
    }
}

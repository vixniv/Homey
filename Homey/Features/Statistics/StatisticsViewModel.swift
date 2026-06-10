//
//  StatisticsViewModel.swift
//  Homey
//
//  Computes weekly statistics by reading through to HouseholdStore.
//  Anchored to the current Mon–Sun week; trends compare to the previous week.
//

import Dependencies
import Foundation
import Observation
import SwiftUI

/// One presentational stat card the view renders.
struct StatCardData: Identifiable {
    let id: String
    let title: String
    let value: String
    let subtitle: String?
    let trendValue: Double?
    let valueColor: Color
}

@MainActor
@Observable
final class StatisticsViewModel {
    @ObservationIgnored @Dependency(\.householdStore) private var store
    @ObservationIgnored @Dependency(\.date.now) private var now

    private let calendar = Calendar(identifier: .gregorian)
    private let dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    func load() async { await store.load() }

    // MARK: - Week math (Monday-start, matches Home week strip)

    private func addingDays(_ days: Int, to date: Date) -> Date {
        calendar.date(byAdding: .day, value: days, to: date) ?? date
    }

    private func weekStart(for date: Date) -> Date {
        let startOfDay = calendar.startOfDay(for: date)
        let weekday = calendar.component(.weekday, from: startOfDay) // 1=Sun…7=Sat
        let daysFromMonday = (weekday + 5) % 7
        return addingDays(-daysFromMonday, to: startOfDay)
    }

    private var thisWeekStart: Date { weekStart(for: now) }
    private var lastWeekStart: Date { addingDays(-7, to: thisWeekStart) }

    private func inWeek(_ date: Date, start: Date) -> Bool {
        date >= start && date < addingDays(7, to: start)
    }

    /// Monday-based index (0=Mon…6=Sun) of `date` within the current week, or -1 if outside.
    private func dayIndex(_ date: Date) -> Int {
        let comps = calendar.dateComponents([.day], from: thisWeekStart, to: calendar.startOfDay(for: date))
        let d = comps.day ?? -1
        return (d >= 0 && d < 7) ? d : -1
    }

    // MARK: - Completion buckets

    private func completions(weekStart start: Date) -> [ChoreCompletion] {
        store.completions.filter { inWeek($0.completedAt, start: start) }
    }
    private var thisWeekCompletions: [ChoreCompletion] { completions(weekStart: thisWeekStart) }
    private var lastWeekCompletions: [ChoreCompletion] { completions(weekStart: lastWeekStart) }

    /// Number of scheduled tasks in the week, summing resolved occurrences across its 7 days.
    private func scheduledCount(weekStart start: Date) -> Int {
        (0..<7).reduce(0) { acc, offset in
            acc + store.occurrences(on: addingDays(offset, to: start)).count
        }
    }

    private func rate(completed: Int, scheduled: Int) -> Double {
        guard scheduled > 0 else { return 0 }
        return min(100, (Double(completed) / Double(scheduled) * 100).rounded())
    }
    private var thisWeekRate: Double { rate(completed: thisWeekCompletions.count, scheduled: scheduledCount(weekStart: thisWeekStart)) }
    private var lastWeekRate: Double { rate(completed: lastWeekCompletions.count, scheduled: scheduledCount(weekStart: lastWeekStart)) }

    // MARK: - On time

    /// The due instant a completion should be judged against.
    private func dueDate(for completion: ChoreCompletion) -> Date? {
        guard let chore = store.chores.first(where: { $0.id == completion.choreId }) else { return nil }
        switch chore.recurrence {
        case .once:
            return chore.dueDate
        case .daily, .weekly:
            return combine(day: completion.completedAt, time: chore.dueDate)
        }
    }

    private func combine(day: Date, time: Date) -> Date {
        let d = calendar.dateComponents([.year, .month, .day], from: day)
        let t = calendar.dateComponents([.hour, .minute], from: time)
        var c = DateComponents()
        c.year = d.year; c.month = d.month; c.day = d.day; c.hour = t.hour; c.minute = t.minute
        return calendar.date(from: c) ?? day
    }

    private var onTimeThisWeek: Int {
        thisWeekCompletions.filter { c in
            guard let due = dueDate(for: c) else { return false }
            return c.completedAt <= due
        }.count
    }

    // MARK: - Overdue (current, not week-scoped)

    private var overdueCount: Int {
        var count = 0
        // One-off chores past due and not done.
        for chore in store.chores where chore.recurrence == .once {
            if chore.dueDate < now && chore.status != .done { count += 1 }
        }
        // Recurring instances this week, up to today, past their due-time and not done.
        let today = calendar.startOfDay(for: now)
        var day = thisWeekStart
        while day <= today {
            for occ in store.occurrences(on: day) where occ.isRecurring {
                if occ.status != .done && occ.dueDate < now { count += 1 }
            }
            day = addingDays(1, to: day)
        }
        return count
    }

    // MARK: - Public outputs

    var cards: [StatCardData] {
        let total = thisWeekCompletions.count
        let totalTrend = Double(total - lastWeekCompletions.count)
        let rateTrend = thisWeekRate - lastWeekRate
        return [
            StatCardData(id: "total", title: "Total Tasks",
                     value: "\(total)",
                     subtitle: trendSubtitle(totalTrend, unit: ""),
                     trendValue: totalTrend, valueColor: .primary),
            StatCardData(id: "rate", title: "Completion Rate",
                     value: "\(Int(thisWeekRate))%",
                     subtitle: trendSubtitle(rateTrend, unit: "%"),
                     trendValue: rateTrend, valueColor: .primary),
            StatCardData(id: "ontime", title: "On Time",
                     value: "\(onTimeThisWeek)",
                     subtitle: "of \(total) tasks",
                     trendValue: nil, valueColor: .primary),
            StatCardData(id: "overdue", title: "Overdue",
                     value: "\(overdueCount)",
                     subtitle: nil, trendValue: nil, valueColor: .red),
        ]
    }

    private func trendSubtitle(_ v: Double, unit: String) -> String {
        let sign = v >= 0 ? "+" : ""
        return "\(sign)\(Int(v))\(unit) vs last week"
    }

    var dailyActivity: [DailyActivityChart.DayData] {
        var counts = Array(repeating: 0, count: 7)
        for c in thisWeekCompletions {
            let idx = dayIndex(c.completedAt)
            if idx >= 0 { counts[idx] += 1 }
        }
        let maxCount = max(1, counts.max() ?? 1)
        return (0..<7).map { i in
            DailyActivityChart.DayData(label: dayLabels[i], value: Double(counts[i]) / Double(maxCount))
        }
    }

    var todayIndex: Int { dayIndex(now) }

    var contributions: [MemberContributionItem] {
        let counts = Dictionary(grouping: thisWeekCompletions, by: { $0.completedBy }).mapValues { $0.count }
        return store.members
            .map { MemberContributionItem(name: $0.name, initials: initials($0.name), taskCount: counts[$0.id] ?? 0) }
            .sorted { $0.taskCount > $1.taskCount }
    }

    private func initials(_ name: String) -> String {
        String(name.prefix(2)).uppercased()
    }
}

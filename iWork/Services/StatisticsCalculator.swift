import Foundation

struct StatisticsTotals: Equatable {
    let hours: Double
    let earnings: Double
}

struct StatisticsCalculator {
    static func totals(_ entries: [WorkEntry]) -> StatisticsTotals {
        entries.reduce(StatisticsTotals(hours: 0, earnings: 0)) { partial, entry in
            StatisticsTotals(
                hours: partial.hours + entry.workedHours,
                earnings: partial.earnings + entry.earnedMoney
            )
        }
    }

    static func totalHours(_ entries: [WorkEntry]) -> Double {
        totals(entries).hours
    }

    static func totalEarnings(_ entries: [WorkEntry]) -> Double {
        totals(entries).earnings
    }

    static func averageHours(_ entries: [WorkEntry]) -> Double {
        entries.isEmpty ? 0 : totalHours(entries) / Double(entries.count)
    }

    static func averageEarnings(_ entries: [WorkEntry]) -> Double {
        entries.isEmpty ? 0 : totalEarnings(entries) / Double(entries.count)
    }

    static func longestDay(_ entries: [WorkEntry]) -> Double {
        entries.reduce(0) { max($0, $1.workedHours) }
    }

    static func dailySummaries(from entries: [WorkEntry], selectedMonth: Date, calendar: Calendar = .current) -> [DailySummary] {
        let dayCount = calendar.range(of: .day, in: .month, for: selectedMonth)?.count ?? 31
        var hoursByDay = Array(repeating: 0.0, count: dayCount + 1)
        var earningsByDay = Array(repeating: 0.0, count: dayCount + 1)

        for entry in entries {
            let day = calendar.component(.day, from: entry.date)
            guard day >= 1, day <= dayCount else { continue }
            hoursByDay[day] += entry.workedHours
            earningsByDay[day] += entry.earnedMoney
        }

        return (1...dayCount).map { day in
            DailySummary(
                id: day,
                day: day,
                hours: hoursByDay[day],
                earnings: earningsByDay[day]
            )
        }
    }

    static func dailySummaries(from entries: [WorkEntry], calendar: Calendar = .current) -> [DailySummary] {
        let groupedEntries = Dictionary(grouping: entries) { calendar.component(.day, from: $0.date) }
        return (1...31).map { day in
            let entriesForDay = groupedEntries[day] ?? []
            let totals = totals(entriesForDay)
            return DailySummary(
                id: day,
                day: day,
                hours: totals.hours,
                earnings: totals.earnings
            )
        }
    }
}

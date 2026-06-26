import Foundation

struct StatisticsCalculator {
    static func totalHours(_ entries: [WorkEntry]) -> Double {
        entries.reduce(0) { $0 + $1.workedHours }
    }

    static func totalEarnings(_ entries: [WorkEntry]) -> Double {
        entries.reduce(0) { $0 + $1.earnedMoney }
    }

    static func averageHours(_ entries: [WorkEntry]) -> Double {
        entries.isEmpty ? 0 : totalHours(entries) / Double(entries.count)
    }

    static func averageEarnings(_ entries: [WorkEntry]) -> Double {
        entries.isEmpty ? 0 : totalEarnings(entries) / Double(entries.count)
    }

    static func longestDay(_ entries: [WorkEntry]) -> Double {
        entries.map(\.workedHours).max() ?? 0
    }

    static func dailySummaries(from entries: [WorkEntry], calendar: Calendar = .current) -> [DailySummary] {
        let groupedEntries = Dictionary(grouping: entries) { calendar.component(.day, from: $0.date) }
        return (1...31).map { day in
            let entriesForDay = groupedEntries[day] ?? []
            return DailySummary(
                id: day,
                day: day,
                hours: totalHours(entriesForDay),
                earnings: totalEarnings(entriesForDay)
            )
        }
    }
}

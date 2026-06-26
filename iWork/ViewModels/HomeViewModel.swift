import Foundation

struct HomeViewModel {
    static func monthEntries(from entries: [WorkEntry], selectedMonth: Date) -> [WorkEntry] {
        entries
            .filter { DateHelper.isInSameMonth($0.date, as: selectedMonth) }
            .sorted { $0.date > $1.date }
    }

    static func totalHours(for entries: [WorkEntry]) -> Double {
        StatisticsCalculator.totalHours(entries)
    }

    static func totalEarnings(for entries: [WorkEntry]) -> Double {
        StatisticsCalculator.totalEarnings(entries)
    }
}

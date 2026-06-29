import Foundation

struct DailySummary: Identifiable, Equatable {
    let id: Int
    let day: Int
    let hours: Double
    let earnings: Double
}

struct StatisticsSnapshot {
    let monthEntries: [WorkEntry]
    let dailySummaries: [DailySummary]
    let goalProgress: GoalProgress
    let goalSegments: [GoalChartSegment]
    let dailyShares: [DailyEarningsShare]
    let totalHours: Double
    let totalEarnings: Double
    let averageHours: Double
    let averageEarnings: Double
    let longestDay: Double
    let workDayCount: Int
}

struct StatisticsViewModel {
    static func snapshot(entries: [WorkEntry], selectedMonth: Date, settings: SettingsModel) -> StatisticsSnapshot {
        let monthEntries = monthEntries(from: entries, selectedMonth: selectedMonth)
        let totals = StatisticsCalculator.totals(monthEntries)
        let averageHours = monthEntries.isEmpty ? 0 : totals.hours / Double(monthEntries.count)
        let averageEarnings = monthEntries.isEmpty ? 0 : totals.earnings / Double(monthEntries.count)
        let longestDay = monthEntries.reduce(0) { max($0, $1.workedHours) }
        let dailySummaries = StatisticsCalculator.dailySummaries(from: monthEntries, selectedMonth: selectedMonth)
        let goalProgress = GoalService.progress(earnedAmount: totals.earnings, goalAmount: settings.monthlyGoalAmount)
        let goalSegments = GoalService.chartSegments(for: goalProgress)
        let dailyShares = GoalService.dailyEarningsShares(entries: monthEntries)

        return StatisticsSnapshot(
            monthEntries: monthEntries,
            dailySummaries: dailySummaries,
            goalProgress: goalProgress,
            goalSegments: goalSegments,
            dailyShares: dailyShares,
            totalHours: totals.hours,
            totalEarnings: totals.earnings,
            averageHours: averageHours,
            averageEarnings: averageEarnings,
            longestDay: longestDay,
            workDayCount: monthEntries.count
        )
    }

    static func monthEntries(from entries: [WorkEntry], selectedMonth: Date) -> [WorkEntry] {
        HomeViewModel.monthEntries(from: entries, selectedMonth: selectedMonth)
            .sorted { $0.date < $1.date }
    }

    static func dailySummaries(from entries: [WorkEntry]) -> [DailySummary] {
        StatisticsCalculator.dailySummaries(from: entries)
    }

    static func goalProgress(for entries: [WorkEntry], settings: SettingsModel) -> GoalProgress {
        GoalService.progress(entries: entries, goalAmount: settings.monthlyGoalAmount)
    }

    static func goalChartSegments(for progress: GoalProgress) -> [GoalChartSegment] {
        GoalService.chartSegments(for: progress)
    }

    static func dailyEarningsShares(from entries: [WorkEntry]) -> [DailyEarningsShare] {
        GoalService.dailyEarningsShares(entries: entries)
    }

    static func totalHours(for entries: [WorkEntry]) -> Double {
        StatisticsCalculator.totalHours(entries)
    }

    static func totalEarnings(for entries: [WorkEntry]) -> Double {
        StatisticsCalculator.totalEarnings(entries)
    }

    static func averageHours(for entries: [WorkEntry]) -> Double {
        StatisticsCalculator.averageHours(entries)
    }

    static func averageEarnings(for entries: [WorkEntry]) -> Double {
        StatisticsCalculator.averageEarnings(entries)
    }

    static func longestDay(for entries: [WorkEntry]) -> Double {
        StatisticsCalculator.longestDay(entries)
    }
}

import Foundation

struct DailySummary: Identifiable, Equatable {
    let id: Int
    let day: Int
    let hours: Double
    let earnings: Double
}

struct StatisticsViewModel {
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

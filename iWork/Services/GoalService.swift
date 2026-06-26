import Foundation

struct GoalProgress: Equatable {
    let goalAmount: Double
    let earnedAmount: Double
    let remainingAmount: Double
    let progress: Double
    let percentText: String
    let isGoalReached: Bool
}

struct GoalChartSegment: Identifiable, Equatable {
    let id: String
    let titleKey: String
    let amount: Double
}

struct GoalService {
    static let defaultGoalAmount = 1_000.0

    static func sanitizedGoalAmount(_ amount: Double) -> Double {
        amount.isFinite && amount > 0 ? amount : defaultGoalAmount
    }

    static func progress(entries: [WorkEntry], goalAmount: Double) -> GoalProgress {
        let goal = sanitizedGoalAmount(goalAmount)
        let earned = max(StatisticsCalculator.totalEarnings(entries), 0)
        let remaining = max(goal - earned, 0)
        let rawProgress = goal > 0 ? earned / goal : 0
        let safeProgress = rawProgress.isFinite ? max(rawProgress, 0) : 0
        let percent = Int((safeProgress * 100).rounded())

        return GoalProgress(
            goalAmount: goal,
            earnedAmount: earned,
            remainingAmount: remaining,
            progress: safeProgress,
            percentText: "\(percent)%",
            isGoalReached: earned >= goal
        )
    }

    static func chartSegments(for progress: GoalProgress) -> [GoalChartSegment] {
        let earnedSlice = max(progress.earnedAmount, progress.isGoalReached ? progress.goalAmount : 0)
        let earnedDisplayAmount = max(earnedSlice, progress.earnedAmount == 0 && progress.remainingAmount == 0 ? 1 : progress.earnedAmount)

        if progress.remainingAmount <= 0 {
            return [GoalChartSegment(id: "earned", titleKey: "goal.alreadyEarned", amount: max(earnedDisplayAmount, 1))]
        }

        return [
            GoalChartSegment(id: "earned", titleKey: "goal.alreadyEarned", amount: max(progress.earnedAmount, 0)),
            GoalChartSegment(id: "remaining", titleKey: "goal.remaining", amount: progress.remainingAmount)
        ]
    }

    static func dailyEarningsShares(entries: [WorkEntry], calendar: Calendar = .current) -> [DailyEarningsShare] {
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.date)
        }

        let totals = grouped.map { date, entries in
            (date: date, amount: StatisticsCalculator.totalEarnings(entries))
        }
        .filter { $0.amount > 0 }
        .sorted { $0.amount > $1.amount }

        let totalEarnings = totals.reduce(0) { $0 + $1.amount }
        let topAmount = totals.first?.amount ?? 0

        return totals.map { item in
            let share = totalEarnings > 0 ? item.amount / totalEarnings : 0
            return DailyEarningsShare(
                id: item.date,
                date: item.date,
                earnedAmount: item.amount,
                percentageShare: share.isFinite ? share : 0,
                isTopDay: item.amount == topAmount && topAmount > 0
            )
        }
    }
}
